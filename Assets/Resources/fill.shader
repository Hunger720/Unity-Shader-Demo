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
				float2 end = float2(0.0, -1.0);
				float2 beg = i.uv - float2(0.5, 0.5);
				float cos_val = dot(beg,end) / (length(beg)*length(end));
				float rad = acos(cos_val);
				float percent = rad / (2 * 3.1415926);
				if (i.uv.x > 0.5) percent = 1 - percent;
				if (percent > _Fill) discard;
				return tex2D(_MainTex, i.uv) * _Color;
			}
			ENDCG
		}
	}
}
