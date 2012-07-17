Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2GQMhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:37:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39439 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2GQMhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:37:00 -0400
Message-ID: <50055C38.3000309@mvista.com>
Date: Tue, 17 Jul 2012 16:36:08 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, gregkh@linuxfoundation.org, ohad@wizery.com,
        linus.walleij@linaro.org, myungjoo.ham@samsung.com,
        rusty@rustcorp.com.au, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] arm/dts: omap4: Add ocp2scp data
References: <1342448023-14438-1-git-send-email-kishon@ti.com> <1342448023-14438-3-git-send-email-kishon@ti.com>
In-Reply-To: <1342448023-14438-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-07-2012 18:13, Kishon Vijay Abraham I wrote:

> Add ocp2scp data node in omap4 device tree file.

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/omap4.dtsi |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 359c497..bda5df3 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -272,5 +272,13 @@
>   			ti,hwmods = "mmc5";
>   			ti,needs-special-reset;
>   		};
> +
> +		ocp2scp@4a0ad000  {

    "reg" property is absent, so why do you give the node name an address postfix?

> +			compatible = "ti,omap-ocp2scp";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			ti,hwmods = "ocp2scp_usb_phy";
> +		};

WBR, Sergei


