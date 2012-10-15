Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2JORms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:42:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56600 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2JORmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:42:47 -0400
Message-ID: <507C4B14.4070809@wwwdotorg.org>
Date: Mon, 15 Oct 2012 11:42:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] iommu: tegra: remove include of <mach/iomap.h>
References: <1349216149-858-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1349216149-858-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 04:15 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Nothing from this file is used, and the file will hopefully be deleted
> soon.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Joerg, if this patch can get into 3.7 (it's late, I know) then that
> would be great. If not, may I please request an ack so I can take the
> change through the Tegra tree in 3.8, since I will probably have cleanup
> patches that depend on this change. Thanks.

Joerg, given 3.7-rc1 is now out, I'd like to take this through the Tegra
tree due to other patches depending on it.

Given the patch is so trivial, I'll probably just apply it anyway soon -
this is more of a heads-up to avoid it being taken through the IOMMU tree.

Thanks.

> This is based on the IOMMU arm/tegra branch.
> ---
>  drivers/iommu/tegra-smmu.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index e1d17fe..e7b56da 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -38,7 +38,6 @@
>  #include <asm/page.h>
>  #include <asm/cacheflush.h>
>  
> -#include <mach/iomap.h>
>  #include <mach/tegra-ahb.h>
>  
>  enum smmu_hwgrp {

