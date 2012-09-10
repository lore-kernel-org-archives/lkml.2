Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2IJQeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:34:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36200 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab2IJQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:34:43 -0400
Message-ID: <504E168C.6060603@ti.com>
Date: Mon, 10 Sep 2012 18:34:20 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH] ARM: dts: AM33XX: fix gpio node numbering to match hardware
References: <1347294020-22661-1-git-send-email-mporter@ti.com>
In-Reply-To: <1347294020-22661-1-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony

Hi Matt,

30 minutes too late for my pull request :-(

There are a couple of am33xx patches under discussion, so I'll take them
and send a for_3.7/dts-part2 pull request if this is not too late for Tony.

On 09/10/2012 06:20 PM, Matt Porter wrote:
> On AM33xx, the datasheet and TRM refer to four GPIO instances that
> are 0-based, GPIO0-3.

Or maybe you should just update the spec to use a 1-based GPIO number
like OMAP :-)

Regards,
Benoit


> 
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
> 

