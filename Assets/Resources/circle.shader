Shader "Custom/circle"{

	Properties{
		_Percent ("Percent", Range(0, 1)) = 1
		_Texture ("Main Tex", 2D) = "white" {}
	}

		SubShader{
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				sampler2D _Texture;
				float4 _Texture_ST;

				struct v2f
				{
					float4 pos : POSITION;
					float2 uv  : TEXCOORD0;
				};

				v2f vert(appdata_full v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _Texture);
					return o;
				}

				float4 frag(v2f i): COLOR
				{
					float4 o = tex2D(_Texture, i.uv);
					if (o.a < 1)
						discard;
					return o;
				}
				ENDCG
		}
	}
}