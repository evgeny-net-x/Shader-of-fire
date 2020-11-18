# Fire-Shader
Implementation of fire-shader on Cg language in Unity ShaderLab. At inspector of Unity will be available properties to configure shader. Files *.png needs to create mask of fire.

## Available properties
| Properties               | Operation              |
| ------------------------ | ---------------------- |
| `Fire texture`           | `2D`                   |
| `Fire direction`         | `Vector`               |
| `Fire color 1`           | `Color`                |
| `Fire color 2`           | `Color`                |
| `Fire color 3`           | `Color`                |
| `Fire edge 1`            | `Range(0, 1)`          |
| `Fire edge 2`            | `Range(0, 1)`          |
| `Fire edge 3`            | `Range(0, 1)`          |
| `Perlin scale`           | `Range(0, 1)`          |
| `Voronoi scale`          | `Range(0, 1)`          |
| `Mix mask and noise`     | `Range(0, 1)`          |
| `Pixel count`            | `Int`                  |
