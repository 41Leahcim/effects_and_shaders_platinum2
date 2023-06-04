Shader "Unlit/Lighting Shader"
{
    Properties
    {
        _Albedo("Albedo", Color) = (1, 1, 1, 1)
        _Shades("Shades", Range(1, 20)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal: TEXCOORD0;
            };

            float4 _Albedo;
            float _Shades;

            v2f vert (appdata v)
            {
                v2f o;

                // Clip the vertex position to object position
                o.vertex = UnityObjectToClipPos(v.vertex);

                // Clip the normal to world normal
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Take the dot product of the normalized worldNormal and light position to calculate how the light hits the object
                float cosineAngle = dot(normalize(i.worldNormal), normalize(_WorldSpaceLightPos0.xyz));

                // Make sure the angle is greater than or equal to 0, to simulate a shadow on the object away from the light
                cosineAngle = max(cosineAngle, 0.0);

                // Limit the number of shades the color can have
                cosineAngle = floor(cosineAngle * _Shades) / _Shades;

                // Calculate and return the actual color
                return _Albedo * cosineAngle;
            }
            ENDCG
        }
    }

    // Enables shadows
    Fallback "VertexLit"
}
