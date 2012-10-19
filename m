Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2JSKzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:55:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40924 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab2JSKzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:55:06 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>
Subject: RE: [PATCH] arm/dts: am33xx rtc node
Thread-Topic: [PATCH] arm/dts: am33xx rtc node
Thread-Index: AQHNreelpxDZ3lcDDk+S2Foc8WtVjpfAdBjQ
Date: Fri, 19 Oct 2012 10:54:53 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA00AFC@DBDE01.ent.ti.com>
References: <1350643825-9657-1-git-send-email-afzal@ti.com>
In-Reply-To: <1350643825-9657-1-git-send-email-afzal@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9JAtFC4017839

+ linux-omap and Daniel

On Fri, Oct 19, 2012 at 16:20:21, Mohammed, Afzal wrote:
> add am33xx rtc node.
> 
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> ---
> 
> Based on v3.7-rc1,
> Dependent on series "rtc: omap dt support (for am33xx)",
> (https://lkml.org/lkml/2012/10/19/163)
> Tested on Beagle Bone.
> 
>  arch/arm/boot/dts/am33xx.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index bb31bff..356711e 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -210,5 +210,14 @@
>  			interrupt-parent = <&intc>;
>  			interrupts = <91>;
>  		};
> +
> +		rtc {
> +			compatible = "ti,da830-rtc";
> +			ti,hwmods = "rtc";
> +			reg = <0x44e3e000 0x1000>;
> +			interrupt-parent = <&intc>;
> +			interrupts = <75
> +				      76>;
> +		};
>  	};
>  };
> -- 
> 1.7.12
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
