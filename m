Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2ENRla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:41:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54972 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab2ENRl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:41:29 -0400
Message-ID: <4FB143C4.6030502@wwwdotorg.org>
Date: Mon, 14 May 2012 11:41:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Kosina <jkosina@suse.cz>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
References: <1336636221-31575-1-git-send-email-hdoyu@nvidia.com> <1336636221-31575-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336636221-31575-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 01:50 AM, Hiroshi DOYU wrote:
> The necessary info is expected to pass from DT.
> 
> For more precise resource reservation, there shouldn't be any
> overlapping of register range between SMMU and MC. SMMU register
> offset needs to be calculated correctly, based on its register bank.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
> This patch requires the following ones, sent earlier:
> 
> DMA window:
> http://article.gmane.org/gmane.linux.ports.tegra/4603

This patch has been merged even though the patch above isn't present in
the kernel anywhere, let alone in the history of the iommu tree. This
breaks compilation in linux-next.

> AHB:
> http://article.gmane.org/gmane.linux.ports.tegra/4657

This patch is in linux-next, but also is not in the history of the iommu
tree, so will break bisection of the iommu tree for Tegra.
