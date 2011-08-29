Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1H2KmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 06:42:18 -0400
Received: from 8bytes.org ([88.198.83.132]:59692 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1H2KmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 06:42:13 -0400
Date: Mon, 29 Aug 2011 12:42:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the iommu tree
Message-ID: <20110829104212.GA5203@8bytes.org>
References: <20110829133237.80467b5d54438ace53b324df@canb.auug.org.au> <CAK=WgbbukmB_HBmfdzt9SQhHyQBbjKYb8xPZPB-vq6Pwu9gFQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbbukmB_HBmfdzt9SQhHyQBbjKYb8xPZPB-vq6Pwu9gFQA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 08:11:53AM +0300, Ohad Ben-Cohen wrote:
> Thank you, Stephen, you're completely right of course.
> 
> Here is what we're missing (patch also attached):
> 
> >From 7a7949ca60bb0d58079b669733f9aa43015ba0f0 Mon Sep 17 00:00:00 2001
> From: Ohad Ben-Cohen <ohad@wizery.com>
> Date: Mon, 29 Aug 2011 07:57:44 +0300
> Subject: [PATCH] iommu: omap: add Kconfig OMAP dependency
> 
> Make CONFIG_OMAP_IOMMU depend on CONFIG_ARCH_OMAP so other
> allmodconfig builds won't fail.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/iommu/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 432463b..d901930 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -110,6 +110,7 @@ config INTR_REMAP
>  # OMAP IOMMU support
>  config OMAP_IOMMU
>  	bool "OMAP IOMMU Support"
> +	depends on ARCH_OMAP
>  	select IOMMU_API
> 
>  config OMAP_IOVMM

Applied to arm/omap and pushed into my next branch, Thanks.

	Joerg

