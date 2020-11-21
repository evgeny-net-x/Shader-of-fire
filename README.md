# Shader of fire
Shader of fire implemented on Cg language for Unity ShaderLab. At inspector of Unity will be available properties to configure shader. Files *.png needs to create mask of fire.

<img src="/example1.png" width="300" height="300"/>

## Available properties
| Properties               | Operation              | Description                   |
| ------------------------ | ---------------------- | ----------------------------- |
| `Fire texture`           | `2D`                   | `Mask of fire`                |
| `Fire direction`         | `Vector`               | `Direction and speed of fire` |
| `Fire color 1`           | `Color`                | `Color of highest fire`       |
| `Fire color 2`           | `Color`                | `Color of middle fire`        |
| `Fire color 3`           | `Color`                | `Color of lowest fire`        |
| `Fire edge 1`            | `Range(0, 1)`          | `Height of highest fire`      |
| `Fire edge 2`            | `Range(0, 1)`          | `Height of middle fire`       |
| `Fire edge 3`            | `Range(0, 1)`          | `Height of lowest fire`       |
| `Perlin scale`           | `Range(0, 1)`          | `Percent of Perlin noise`     |
| `Voronoi scale`          | `Range(0, 1)`          | `Percent of Voronoi noise`    |
| `Mix mask and noise`     | `Range(0, 1)`          | `Percent of mask`             |
| `Pixel count`            | `Int`                  | `Amount of pixelation`        |

## Examples:
<img src="/example2.png" alt="sdf" width="300" height="300"/><img src="/example3.png" width="300" height="300"/>
