Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1ITRsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:48:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50189 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1ITRsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:48:08 -0400
Date: Tue, 20 Sep 2011 11:41:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, nicolas.pitre@linaro.org,
        Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST 2/2] arm/dt: Tegra: Add support-8bit to SDHCI nodes
Message-ID: <20110920174155.GG7781@ponder.secretlab.ca>
References: <1316537186-26753-1-git-send-email-swarren@nvidia.com>
 <1316537186-26753-2-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316537186-26753-2-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:46:26AM -0600, Stephen Warren wrote:
> For Seaboard's internal eMMC, this makes the difference between a
> 5.5MB/s and 10.2MB/s transfer rate. On Harmony, there wasn't any
> measurable difference on my cheap/slow ~2MB/s card.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/arm/boot/dts/tegra-harmony.dts  |    1 +
>  arch/arm/boot/dts/tegra-seaboard.dts |    4 ++++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
> index e581866..0e225b8 100644
> --- a/arch/arm/boot/dts/tegra-harmony.dts
> +++ b/arch/arm/boot/dts/tegra-harmony.dts
> @@ -66,5 +66,6 @@
>  		cd-gpios = <&gpio 58 0>; /* gpio PH2 */
>  		wp-gpios = <&gpio 59 0>; /* gpio PH3 */
>  		power-gpios = <&gpio 70 0>; /* gpio PI6 */
> +		support-8bit;
>  	};
>  };
> diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
> index 64cedca..a72299b 100644
> --- a/arch/arm/boot/dts/tegra-seaboard.dts
> +++ b/arch/arm/boot/dts/tegra-seaboard.dts
> @@ -25,4 +25,8 @@
>  		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
>  		power-gpios = <&gpio 70 0>; /* gpio PI6 */
>  	};
> +
> +	sdhci@c8000600 {
> +		support-8bit;
> +	};
>  };
> -- 
> 1.7.0.4
> 
