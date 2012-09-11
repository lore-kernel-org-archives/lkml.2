Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2IKIX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:23:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42263 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2IKIXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:23:52 -0400
Message-ID: <504EF4FD.2080001@ti.com>
Date: Tue, 11 Sep 2012 10:23:25 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rnayak@ti.com>, <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <ohad@wizery.com>,
        <linus.walleij@linaro.org>, <myungjoo.ham@samsung.com>,
        <rusty@rustcorp.com.au>, <swarren@nvidia.com>
Subject: Re: [PATCH] arm/dts: omap: Add omap-usb2 dt data
References: <1347343932-3656-1-git-send-email-kishon@ti.com>
In-Reply-To: <1347343932-3656-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 09/11/2012 08:12 AM, Kishon Vijay Abraham I wrote:
> Add omap-usb2 data node in omap4 device tree file. Since omap-usb2 is
> connected to ocp2scp, omap-usb2 dt data is added as a child node
> of ocp2scp.

Could you add more details about the omap-usb2?

You must update the Documentation binding with that compatible name.
Is it already part of the driver serie? The MUSB driver is referring to
"ti,musb-omap2430" only.

> 
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> Applies on
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git for-next
>  arch/arm/boot/dts/omap4.dtsi |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 8a780b2..bdc21f1 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -302,6 +302,11 @@
>  			#size-cells = <1>;
>  			ranges;
>  			ti,hwmods = "ocp2scp_usb_phy";

There is no ocp2scp_usb_phy in the current omap4.dtsi?
What base did you used?

You have to use lo/devel-dt branch as a base. All the latest DTS patches
an in there for 3.7.

Regards,
Benoit

> +			usb2phy@4a0ad080 {
> +				compatible = "ti,omap-usb2";
> +				reg = <0x4a0ad080 0x58>,
> +				      <0x4a002300 0x4>;
> +			};
>  		};
>  	};
>  };
> 

