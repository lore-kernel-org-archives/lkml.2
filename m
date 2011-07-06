Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1GFFuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:50:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47097 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1GFFuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:50:21 -0400
Date: Tue, 5 Jul 2011 23:50:18 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ARM: tegra: Harmony: Use engineering names in DT
 compatible property
Message-ID: <20110706055018.GF9978@ponder.secretlab.ca>
References: <1309897408-23085-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309897408-23085-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:23:28PM -0600, Stephen Warren wrote:
> Engineering names are more stable than marketing names. Hence, use them
> for Device Tree compatible properties instead.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Grant, this is against devicetree/arm, and only makes sense there; I'll
> send a separate patch for the equivalent change in devicetree/test, since
> the file is radically different there.

devicetree/arm actually does track devicetree/test, just a subset of
the patches in it (although it isn't obvious since I use stgit to make
devicetree/arm a stable branch that never rebases.

I'll make sure both devicetree/arm and devicetree/test are fixed up.

g.

> 
>  arch/arm/boot/dts/tegra-harmony.dts |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
> index 81032e7..4ad8ade 100644
> --- a/arch/arm/boot/dts/tegra-harmony.dts
> +++ b/arch/arm/boot/dts/tegra-harmony.dts
> @@ -3,5 +3,5 @@
>  
>  / {
>  	model = "NVIDIA Tegra2 Harmony evaluation board";
> -	compatible = "nvidia,harmony", "nvidia,tegra250";
> +	compatible = "nvidia,harmony", "nvidia,tegra20";
>  };
> -- 
> 1.7.0.4
> 
