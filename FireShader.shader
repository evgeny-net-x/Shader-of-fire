Shader "Unlit/FireShader"
{
        Properties
        {
                [NoScaleOffset] [MainTexture] _FireTex("Fire Texture", 2D) = "white" {}
		_FireDir("Fire Direction", Vector) = (0, 1, 0, 0)
		
		_FireColor1("Fire Color1", Color) = (1, 1, 0, 0)
		_FireEdge1("Fire Edge1", Range(0, 1)) = 0.15
		
		_FireColor2("Fire Color2", Color) = (1, 1, 0, 0)
		_FireEdge2("Fire Edge2", Range(0, 1)) = 0.30
		
		_FireColor3("Fire Color3", Color) = (1, 1, 0, 0)
		_FireEdge3("Fire Edge3", Range(0, 1)) = 0.60
		
		_PerlinScale("Perlin Scale", Range(0, 1)) = 0.5
		_VoronoiScale("Voronoi Scale", Range(0, 1)) = 0.5
		_MixMaskAndNoise("Mix Mask And Noise", Range(0, 1)) = 0.5
		_PixelCount("Pixel Count", Int) = 30
        }
      
        SubShader
        {
                Tags {"Queue" = "Transparent"}
            Blend SrcAlpha OneMinusSrcAlpha
                Pass
                {
                        CGPROGRAM
                    
			#pragma vertex vert
			#pragma fragment frag
			
			struct appdata {
				float2 uv_FireTex: TEXCOORD0;
				float4 vertex: POSITION;
			};
      
			struct v2f {
				float2 uv_FireTex: TEXCOORD0;
				float4 vertex: SV_POSITION;
			};
			
			float rand1dTo1d(float2 value, float mutator = 0.546)
			{
				return frac(sin(value + mutator) * 143758.5453);
			}
			
			float rand2dTo1d(float2 value, float2 dotDir = float2(12.9898, 78.233))
			{
				float2 smallValue = sin(value);
				float random = dot(smallValue, dotDir);
				random = frac(sin(random) * 143758.5453);
				return random;
			}
			
			float2 rand2dTo2d(float2 value)
			{
				return float2(
					rand2dTo1d(value, float2(12.989, 78.233)),
					rand2dTo1d(value, float2(39.346, 11.135))
			   	 );
			}
			
			inline float easeIn(float interpolator)
			{
				return interpolator * interpolator;
			}
			
			float easeOut(float interpolator)
			{
				return 1 - easeIn(1 - interpolator);
			}
			
			float easeInOut(float interpolator)
			{
				float easeInValue = easeIn(interpolator);
				float easeOutValue = easeOut(interpolator);
				return lerp(easeInValue, easeOutValue, interpolator);
			}
			
			float voronoiNoise(float2 value)
			{
				float2 baseCell = floor(value);

				float minDistToCell = 10;
				
				[unroll]
				for(int x = -1; x <= 1; x++) {
					[unroll]
					for(int y = -1; y <= 1; y++) {
						float2 cell = baseCell + float2(x, y);
				    		float2 cellPosition = cell + rand2dTo2d(cell);
						float2 toCell = cellPosition - value;
						float distToCell = length(toCell);
						
						if(distToCell < minDistToCell)
							minDistToCell = distToCell;
					}
				}
				
				return minDistToCell;
			}
			
			float perlinNoise(float2 value)
			{
			    	float fraction = frac(value);
				float interpolator = easeInOut(fraction);

				float previousCellInclination = 2*rand1dTo1d(floor(value)) - 1;
				float previousCellLinePoint = previousCellInclination * fraction;

				float nextCellInclination = 2*rand1dTo1d(ceil(value)) - 1;
				float nextCellLinePoint = nextCellInclination * (fraction-1);

				return lerp(previousCellLinePoint, nextCellLinePoint, interpolator);
			}

                    
                        v2f vert(appdata IN)
                        {
				v2f OUT;
				
				OUT.uv_FireTex = IN.uv_FireTex;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				
				return OUT;
                        }
                    
			float2 _FireDir;
			float _VoronoiScale;
			float _PerlinScale;
			float _MixNoises;
			float _MixMaskAndNoise;
			int _PixelCount;
                        fixed4 _FireColor;
			fixed4 _FireColor1;
			fixed4 _FireColor2;
			fixed4 _FireColor3;
			fixed _FireEdge1;
			fixed _FireEdge2;
			fixed _FireEdge3;
                        sampler2D _FireTex;
			
			fixed4 scale(fixed4 vec, float s)
			{
				vec.r *= s;
				vec.g *= s;
				vec.b *= s;
				vec.a *= s;
				
				return vec;
			}
			
			fixed2 scale(fixed2 vec, float scale)
			{
				vec.x *= scale;
				vec.y *= scale;
				
				return vec;
			}
			
			fixed2 pixelatedUV(fixed2 UV, float size)
			{
				UV = scale(round(scale(UV, size)), 1/size);
				
				return UV;
			}
			
			fixed colorToAlpha(fixed4 color)
			{
				fixed4 black = (0, 1, 1, 1);
				fixed alpha = (color.r*black.r + color.g*black.g + color.b*black.b)/(length(color)*length(black));
				
				return alpha;
			}
			
			fixed2 alphaToColor2(fixed alpha)
			{
				return fixed2(alpha, alpha);
			}
			
			fixed4 getFireColor(fixed2 UV)
			{
				float2 offset;
				offset.x = _FireDir.x * _Time;
				offset.y = _FireDir.y * _Time;
				
				fixed voronoiAlpha = voronoiNoise((UV+offset)/_VoronoiScale);
				fixed perlinAlpha = perlinNoise((UV+offset)/_PerlinScale);
				
				fixed noiseAlpha = lerp(perlinAlpha, voronoiAlpha, 0.5);
				UV = lerp(alphaToColor2(noiseAlpha), UV, _MixMaskAndNoise);
				
				fixed4 color = tex2D(_FireTex, UV);
				return color;
			}
			
			fixed4 splitFire(fixed alpha)
			{
				fixed part1 = step(_FireEdge1, alpha);
				fixed part2 = step(_FireEdge2, alpha);
				fixed part3 = step(_FireEdge3, alpha);
				
				fixed part12 = part1 - part2;
				fixed part23 = part2 - part3;
				
				_FireColor1 = scale(_FireColor1, part12);
				_FireColor2 = scale(_FireColor2, part23);
				_FireColor3 = scale(_FireColor3, part3);
				
				fixed4 color = _FireColor1 + _FireColor2 + _FireColor3;
				color.a = part1;

				return color;
			}

                        fixed4 frag(v2f IN): COLOR
                        {
				fixed2 UV = IN.uv_FireTex;
				fixed2 pixelUV = pixelatedUV(UV, _PixelCount);
				
				fixed4 fireColor = getFireColor(pixelUV);
				fixed fireAlpha = colorToAlpha(fireColor);
				fixed4 splitedFireColor = splitFire(fireAlpha);
				return splitedFireColor;
			}
                    
                        ENDCG
                }
        }
}
