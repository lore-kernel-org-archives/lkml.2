Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2LSMd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:33:59 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34581 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2LSMdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:33:52 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] dt: fix tegra SPI binding examples
To: Allen Martin <amartin@nvidia.com>, swarren@wwwdotorg.org,
        ldewangan@nvidia.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
In-Reply-To: <1355511912-23733-1-git-send-email-amartin@nvidia.com>
References: <1355511912-23733-1-git-send-email-amartin@nvidia.com>
Date: Wed, 19 Dec 2012 12:33:48 +0000
Message-Id: <20121219123348.19AFF3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 11:05:12 -0800, Allen Martin <amartin@nvidia.com> wrote:
> Fix name of slink binding and address of sflash example to make it
> self consistent.
> 
> Change-Id: Ia89c3017c958bdf670036caf516eabce6f893096

Applied, thanks.

g.

> Signed-off-by: Allen Martin <amartin@nvidia.com>
> ---
>  Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt |    2 +-
>  Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt b/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
> index 8cf24f6..7b53da5 100644
> --- a/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
> +++ b/Documentation/devicetree/bindings/spi/nvidia,tegra20-sflash.txt
> @@ -13,7 +13,7 @@ Recommended properties:
>  
>  Example:
>  
> -spi@7000d600 {
> +spi@7000c380 {
>  	compatible = "nvidia,tegra20-sflash";
>  	reg = <0x7000c380 0x80>;
>  	interrupts = <0 39 0x04>;
> diff --git a/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt b/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
> index f5b1ad1..eefe15e 100644
> --- a/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
> +++ b/Documentation/devicetree/bindings/spi/nvidia,tegra20-slink.txt
> @@ -13,7 +13,7 @@ Recommended properties:
>  
>  Example:
>  
> -slink@7000d600 {
> +spi@7000d600 {
>  	compatible = "nvidia,tegra20-slink";
>  	reg = <0x7000d600 0x200>;
>  	interrupts = <0 82 0x04>;
> -- 
> 1.7.10.4
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
