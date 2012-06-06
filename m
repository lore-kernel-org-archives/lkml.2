Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab2FFRrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:47:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45615 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2FFRrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:47:20 -0400
Message-ID: <4FCF97A5.5040008@wwwdotorg.org>
Date: Wed, 06 Jun 2012 11:47:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, vinod.koul@intel.com
CC: dan.j.williams@intel.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V5 2/2] dma: tegra: add dmaengine based dma driver
References: <1338960327-31453-1-git-send-email-ldewangan@nvidia.com> <1338960327-31453-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1338960327-31453-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 11:25 PM, Laxman Dewangan wrote:
> Add dmaengine based NVIDIA's Tegra APB DMA driver.
> This driver support the slave mode of data transfer from
> peripheral to memory and vice versa.
> The driver supports for the cyclic and non-cyclic mode
> of data transfer.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Laxman, what are you plans for enabling this and replacing the existing
non-dmaengine APB DMA driver? We will need to convert:

* The fuse WAR stuff in arch/arm/mach-tegra
* The ASoC driver in sound/soc/tegra

This will require some thought and dependency management between the
various subsystems.

Vinod,

It may be best to apply this series along in a topic branch that you
merge into the dmaengine branch, and I can pull into Tegra if/when I
need. Or, if you ack it, I can take it all through the Tegra tree if you
want. That wouldn't allow patch 1 to be use by others though.

Thanks.
