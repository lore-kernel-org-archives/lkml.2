Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2HCRX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:23:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45295 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab2HCRX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:23:56 -0400
Message-ID: <501C08CB.3060701@mvista.com>
Date: Fri, 03 Aug 2012 21:22:19 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 1/4] arm/dts: omap5-evm: Add I2C support
References: <1343997486-710-1-git-send-email-sourav.poddar@ti.com> <1343997486-710-2-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1343997486-710-2-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/03/2012 04:38 PM, Sourav Poddar wrote:

> Add I2C data node in omap5 device tree file.

> Tested on omap5430 sdp.

> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
>  arch/arm/boot/dts/omap5.dtsi |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 57e5270..6b68dfe 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -145,6 +145,41 @@
>  			#interrupt-cells = <1>;
>  		};
>  
> +		i2c1: i2c@48070000 {
> +			compatible = "ti,omap4-i2c";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			ti,hwmods = "i2c1";

   Address postfix in the node name and no "reg" property?

WBR, Sergei

