Shader "Custom/fill"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1, 1, 1, 1)
		_Fill ("Fill", Range(0, 1)) = 1
	}
	SubShader
	{
		Tags
		{ 
			"RenderType"="Opaque"
			"Queue" = "Transparent"
		}
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Fill;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 end_dir = float2(0.0, -1.0);
				float2 start_dir = i.uv - float2(0.5, 0.5);
				float d = dot(start_dir, end_dir);
				float c = d / (length(start_dir)*length(end_dir));
				float r = acos(c);
				float p = r / (2 * 3.1415926);
				if (i.uv.x > 0.5) p = 1 - p;
				if (p > _Fill) discard;
				return tex2D(_MainTex, i.uv) * _Color;
			}
			ENDCG
		}
	}
}
