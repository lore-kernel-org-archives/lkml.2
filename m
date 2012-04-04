Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab2DDNvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:51:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57523 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab2DDNvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:51:48 -0400
Message-ID: <4F7C51EA.1040902@ti.com>
Date: Wed, 4 Apr 2012 15:51:38 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 1/2] arm/dts: omap4-sdp: Add keypad data
References: <1333546221-19700-1-git-send-email-sourav.poddar@ti.com> <1333546221-19700-2-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1333546221-19700-2-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2012 3:30 PM, Sourav Poddar wrote:
> This patch add keypad data node in omap4 device tree
> file.

Nit #2: Never write "this patch" in a patch changelog... Because at some 
point it will become a commit in a GIT tree.

I think AKPM wrote something on that.

Benoit

>
> Cc: Benoit Cousson<b-cousson@ti.com>
> Cc: Rob Herring<rob.herring@calxeda.com>
> Cc: Grant Likely<grant.likely@secretlab.ca>
> Cc: Felipe Balbi<balbi@ti.com>
> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
> ---
>   arch/arm/boot/dts/omap4-sdp.dts |  291 +++++++++++++++++++++++++++++++++++++++
>   arch/arm/boot/dts/omap4.dtsi    |    5 +
>   2 files changed, 296 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/omap4-sdp.dts b/arch/arm/boot/dts/omap4-sdp.dts
> index 63c6b2b..ac855b8 100644
> --- a/arch/arm/boot/dts/omap4-sdp.dts
> +++ b/arch/arm/boot/dts/omap4-sdp.dts
> @@ -17,4 +17,295 @@
>   		device_type = "memory";
>   		reg =<0x80000000 0x40000000>; /* 1 GB */
>   	};
> +
> +	keypad@4ae1c000 {
> +		keypad,num-rows =<8>;
> +		keypad,num-columns =<8>;
> +
> +		key_E {
> +			keypad,row =<0>;
> +			keypad,column =<0>;
> +			linux,code =<18>;
> +		};
> +		key_R {
> +			keypad,row =<0>;
> +			keypad,column =<1>;
> +			linux,code =<19>;
> +		};
> +		key_T {
> +			keypad,row =<0>;
> +			keypad,column =<2>;
> +			linux,code =<20>;
> +		};
> +		key_HOME {
> +			keypad,row =<0>;
> +			keypad,column =<3>;
> +			linux,code =<102>;
> +		};
> +		key_F5 {
> +			keypad,row =<0>;
> +			keypad,column =<4>;
> +			linux,code =<63>;
> +		};
> +		key_I {
> +			keypad,row =<0>;
> +			keypad,column =<6>;
> +			linux,code =<23>;
> +		};
> +		key_LEFTSHIFT {
> +			keypad,row =<0>;
> +			keypad,column =<7>;
> +			linux,code =<42>;
> +		};
> +		key_D {
> +			keypad,row =<1>;
> +			keypad,column =<0>;
> +			linux,code =<32>;
> +		};
> +		key_F {
> +			keypad,row =<1>;
> +			keypad,column =<1>;
> +			linux,code =<33>;
> +		};
> +		key_G {
> +			keypad,row =<1>;
> +			keypad,column =<2>;
> +			linux,code =<34>;
> +		};
> +		key_SEND {
> +			keypad,row =<1>;
> +			keypad,column =<3>;
> +			linux,code =<84>;
> +		};
> +		key_F6 {
> +			keypad,row =<1>;
> +			keypad,column =<4>;
> +			linux,code =<64>;
> +		};
> +		key_K {
> +			keypad,row =<1>;
> +			keypad,column =<6>;
> +			linux,code =<37>;
> +		};
> +		key_ENTER {
> +			keypad,row =<1>;
> +			keypad,column =<7>;
> +			linux,code =<28>;
> +		};
> +		key_X {
> +			keypad,row =<2>;
> +			keypad,column =<0>;
> +			linux,code =<45>;
> +		};
> +		key_C {
> +			keypad,row =<2>;
> +			keypad,column =<1>;
> +			linux,code =<46>;
> +		};
> +		key_V {
> +			keypad,row =<2>;
> +			keypad,column =<2>;
> +			linux,code =<47>;
> +		};
> +		key_END {
> +			keypad,row =<2>;
> +			keypad,column =<3>;
> +			linux,code =<107>;
> +		};
> +		key_F7 {
> +			keypad,row =<2>;
> +			keypad,column =<4>;
> +			linux,code =<65>;
> +		};
> +		key_DOT {
> +			keypad,row =<2>;
> +			keypad,column =<6>;
> +			linux,code =<52>;
> +		};
> +		key_CAPSLOCK {
> +                        keypad,row =<2>;
> +                        keypad,column =<7>;
> +                        linux,code =<58>;
> +                };
> +		key_Z {
> +			keypad,row =<3>;
> +			keypad,column =<0>;
> +			linux,code =<44>;
> +		};
> +		key_KPLUS {
> +			keypad,row =<3>;
> +			keypad,column =<1>;
> +			linux,code =<78>;
> +		};
> +		key_B {
> +			keypad,row =<3>;
> +			keypad,column =<2>;
> +			linux,code =<48>;
> +		};
> +		key_F1 {
> +			keypad,row =<3>;
> +			keypad,column =<3>;
> +			linux,code =<59>;
> +		};
> +		key_F8 {
> +			keypad,row =<3>;
> +			keypad,column =<4>;
> +			linux,code =<66>;
> +		};
> +		key_O {
> +			keypad,row =<3>;
> +			keypad,column =<6>;
> +			linux,code =<24>;
> +                };
> +		key_SPACE {
> +			keypad,row =<3>;
> +			keypad,column =<7>;
> +			linux,code =<57>;
> +                };
> +		key_W {
> +			keypad,row =<4>;
> +			keypad,column =<0>;
> +			linux,code =<17>;
> +                };
> +		key_Y {
> +			keypad,row =<4>;
> +			keypad,column =<1>;
> +			linux,code =<21>;
> +		};
> +		key_U {
> +			keypad,row =<4>;
> +			keypad,column =<2>;
> +			linux,code =<22>;
> +		};
> +		key_F2 {
> +			keypad,row =<4>;
> +			keypad,column =<3>;
> +			linux,code =<60>;
> +		};
> +		key_VOLUMEUP {
> +			keypad,row =<4>;
> +			keypad,column =<4>;
> +			linux,code =<115>;
> +		};
> +		key_L {
> +			keypad,row =<4>;
> +			keypad,column =<6>;
> +			linux,code =<38>;
> +		};
> +		key_LEFT {
> +			keypad,row =<4>;
> +			keypad,column =<7>;
> +			linux,code =<105>;
> +		};
> +		key_S {
> +			keypad,row =<5>;
> +			keypad,column =<0>;
> +			linux,code =<31>;
> +		};
> +		key_H {
> +			keypad,row =<5>;
> +			keypad,column =<1>;
> +			linux,code =<35>;
> +		};
> +		key_J {
> +			keypad,row =<5>;
> +			keypad,column =<2>;
> +			linux,code =<36>;
> +		};
> +		key_F3 {
> +			keypad,row =<5>;
> +			keypad,column =<3>;
> +			linux,code =<61>;
> +		};
> +		key_F9 {
> +			keypad,row =<5>;
> +			keypad,column =<4>;
> +			linux,code =<67>;
> +		};
> +		key_VOLUMEDOWN {
> +			keypad,row =<5>;
> +			keypad,column =<5>;
> +			linux,code =<114>;
> +		};
> +		key_M {
> +			keypad,row =<5>;
> +			keypad,column =<6>;
> +			linux,code =<50>;
> +		};
> +		key_RIGHT {
> +			keypad,row =<5>;
> +			keypad,column =<7>;
> +			linux,code =<106>;
> +		};
> +		key_Q {
> +			keypad,row =<6>;
> +			keypad,column =<0>;
> +			linux,code =<16>;
> +		};
> +		key_A {
> +			keypad,row =<6>;
> +			keypad,column =<1>;
> +			linux,code =<30>;
> +                };
> +		key_N {
> +			keypad,row =<6>;
> +			keypad,column =<2>;
> +			linux,code =<49>;
> +                };
> +		key_BACK {
> +			keypad,row =<6>;
> +			keypad,column =<3>;
> +			linux,code =<92>;
> +                };
> +		key_BACKSPACE {
> +			keypad,row =<6>;
> +			keypad,column =<4>;
> +			linux,code =<14>;
> +		};
> +		key_P {
> +			keypad,row =<6>;
> +			keypad,column =<6>;
> +			linux,code =<25>;
> +		};
> +		key_UP {
> +			keypad,row =<6>;
> +			keypad,column =<7>;
> +			linux,code =<103>;
> +		};
> +		key_PROG1 {
> +			keypad,row =<7>;
> +			keypad,column =<0>;
> +			linux,code =<148>;
> +		};
> +		key_PROG2 {
> +			keypad,row =<7>;
> +			keypad,column =<1>;
> +			linux,code =<149>;
> +		};
> +		key_PROG3 {
> +			keypad,row =<7>;
> +			keypad,column =<2>;
> +			linux,code =<202>;
> +                };
> +		key_PROG4 {
> +			keypad,row =<7>;
> +			keypad,column =<3>;
> +			linux,code =<203>;
> +		};
> +		key_F4 {
> +			keypad,row =<7>;
> +			keypad,column =<4>;
> +			linux,code =<62>;
> +		};
> +		key_Ok {
> +			keypad,row =<7>;
> +			keypad,column =<6>;
> +			linux,code =<352>;
> +		};
> +		key_DOWN {
> +			keypad,row =<7>;
> +			keypad,column =<7>;
> +			linux,code =<108>;
> +		};
> +	};
>   };
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 3d35559..e0f678a 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -156,4 +156,9 @@
>   			ti,hwmods = "i2c4";
>   		};
>   	};
> +
> +	keypad@4ae1c000 {
> +		compatible = "ti,omap4-keypad";
> +		ti,hwmods = "kbd";
> +	};
>   };

