Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2IKE50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 00:57:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43012 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2IKE5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 00:57:22 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Porter, Matt" <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Cousson, Benoit" <b-cousson@ti.com>
Subject: RE: [PATCH] ARM: dts: AM33XX: fix gpio node numbering to match
 hardware
Thread-Topic: [PATCH] ARM: dts: AM33XX: fix gpio node numbering to match
 hardware
Thread-Index: AQHNj3AJis8p+E5khkyyI5jRiOW9P5eEk2Ow
Date: Tue, 11 Sep 2012 04:57:08 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EAB03D3@DBDE01.ent.ti.com>
References: <1347294020-22661-1-git-send-email-mporter@ti.com>
In-Reply-To: <1347294020-22661-1-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 21:50:20, Porter, Matt wrote:
> On AM33xx, the datasheet and TRM refer to four GPIO instances that
> are 0-based, GPIO0-3.
> 

Thanks Matt,
I think Anil labeled it as gpio1-4 due to hwmod naming convention, as you 
can not have gpioo id = 0 (refer to arch/arm/mach-omap2/gpio.c).

But in case of DT we should simply follow TRM/Spec, as naming convention is 
based on base-addr and not id, so your patch looks good me.

Thanks,
Vaibhav

> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/boot/dts/am33xx.dtsi |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index bb31bff..1369bfc 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -62,7 +62,7 @@
>  			reg = <0x48200000 0x1000>;
>  		};
>  
> -		gpio1: gpio@44e07000 {
> +		gpio0: gpio@44e07000 {
>  			compatible = "ti,omap4-gpio";
>  			ti,hwmods = "gpio1";
>  			gpio-controller;
> @@ -74,7 +74,7 @@
>  			interrupts = <96>;
>  		};
>  
> -		gpio2: gpio@4804c000 {
> +		gpio1: gpio@4804c000 {
>  			compatible = "ti,omap4-gpio";
>  			ti,hwmods = "gpio2";
>  			gpio-controller;
> @@ -86,7 +86,7 @@
>  			interrupts = <98>;
>  		};
>  
> -		gpio3: gpio@481ac000 {
> +		gpio2: gpio@481ac000 {
>  			compatible = "ti,omap4-gpio";
>  			ti,hwmods = "gpio3";
>  			gpio-controller;
> @@ -98,7 +98,7 @@
>  			interrupts = <32>;
>  		};
>  
> -		gpio4: gpio@481ae000 {
> +		gpio3: gpio@481ae000 {
>  			compatible = "ti,omap4-gpio";
>  			ti,hwmods = "gpio4";
>  			gpio-controller;
> -- 
> 1.7.9.5
> 
> 

