Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2FKWol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:44:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48753 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2FKWok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:44:40 -0400
Message-ID: <4FD67492.2040102@ti.com>
Date: Tue, 12 Jun 2012 00:43:30 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: <arm@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>,
        <robherring2@gmail.com>
Subject: Re: [PATCH] ARM: omap: Fix dts files w/ status property: "disable"
 -> "disabled"
References: <1339441785-14641-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339441785-14641-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/2012 9:09 PM, Roland Stigge wrote:
> This patches fixes some status = "disable" strings to "disabled", the correct
> way of disabling nodes in the devicetree.
>
> Just the OMAP part here, the rest goes via other patches and trees.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Benoit Cousson <b-cousson@ti.com>

> Applies to v3.5-rc2
>
>   arch/arm/boot/dts/omap3-beagle.dts |    4 +--
>   arch/arm/boot/dts/omap4-panda.dts  |    6 ++---
>   arch/arm/boot/dts/omap4-sdp.dts    |    4 +--
>   arch/arm/boot/dts/tegra20.dtsi     |   36 +++++++++++++++++------------------
>   arch/arm/boot/dts/tegra30.dtsi     |   38 ++++++++++++++++++-------------------

Nit: the diffstat does not match that patch, but anyway that will not go 
into the changelog.

>   5 files changed, 44 insertions(+), 44 deletions(-)
>
> --- linux-2.6.orig/arch/arm/boot/dts/omap3-beagle.dts
> +++ linux-2.6/arch/arm/boot/dts/omap3-beagle.dts
> @@ -61,9 +61,9 @@
>   };
>
>   &mmc2 {
> -	status = "disable";
> +	status = "disabled";
>   };
>
>   &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>   };
> --- linux-2.6.orig/arch/arm/boot/dts/omap4-panda.dts
> +++ linux-2.6/arch/arm/boot/dts/omap4-panda.dts
> @@ -74,15 +74,15 @@
>   };
>
>   &mmc2 {
> -	status = "disable";
> +	status = "disabled";
>   };
>
>   &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>   };
>
>   &mmc4 {
> -	status = "disable";
> +	status = "disabled";
>   };
>
>   &mmc5 {
> --- linux-2.6.orig/arch/arm/boot/dts/omap4-sdp.dts
> +++ linux-2.6/arch/arm/boot/dts/omap4-sdp.dts
> @@ -147,11 +147,11 @@
>   };
>
>   &mmc3 {
> -	status = "disable";
> +	status = "disabled";
>   };
>
>   &mmc4 {
> -	status = "disable";
> +	status = "disabled";
>   };
>
>   &mmc5 {
>


