Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab2FUQTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:19:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50673 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675Ab2FUQTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:19:05 -0400
Message-ID: <4FE34973.1020400@wwwdotorg.org>
Date: Thu, 21 Jun 2012 10:18:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [v2 1/5] iommu: Add DMA window parser, of_get_dma_window()
References: <4FE20457.8090307@wwwdotorg.org><20120621.094611.2108645748323641310.hdoyu@nvidia.com><4FE2C5F3.1010007@wwwdotorg.org> <20120621.113023.1324461719984328307.hdoyu@nvidia.com>
In-Reply-To: <20120621.113023.1324461719984328307.hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 02:30 AM, Hiroshi Doyu wrote:
> From: Hiroshi DOYU <hdoyu@nvidia.com>
> 
> This code was based on:
>     "arch/microblaze/kernel/prom_parse.c"
>     "arch/powerpc/kernel/prom_parse.c"
> 
> Can replace "of_parse_dma_window()" in the above. This supports
> different formats flexibly. "prefix" can be configured if any. "busno"
> and "index" are optionally specified. Set NULL and 0 if not used.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

BTW, I only see patches 1 & 2 of 5 in this series; did you only mean to
post just 2 patches or did the others get lost on the way to my system
somehow?
