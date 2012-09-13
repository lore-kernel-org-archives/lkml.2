Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab2IMXf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:35:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33856 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033Ab2IMXfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:35:25 -0400
Message-ID: <50526DB8.3090808@wwwdotorg.org>
Date: Thu, 13 Sep 2012 17:35:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, grant.likely@secretlab.ca, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/5] ARM: tegra: move all APB DMA client to dmaengine
 based driver
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 08:13 AM, Laxman Dewangan wrote:
> This patch series enable the dmaengine based Tegra APB DMA driver
> and remove the support code for the legacy dma driver from different
> APB DMA clients.
> Patch 1 enable the dmaengine based dma drie and disable the legacy dma driver
>         in config file.
> Patch 2 remove the legacy dma driver.
> Patch 3,4, 5 remove the support code from different APB DMA clients to support
>         legacy dma driver.
> 
> Please note that this series will depends on patch
> dma: tegra: enable/disable dma clock
> which is not in 3.6-rc1 but will be available in next RC (rc2) of 3.6 as
> part of fixes.

I have applied this series to Tegra's for-3.7/dmaengine branch. Right
now, that branch is based directly on Mark Brown's ASoC for-3.6 branch
in order to pick up the fix it depends on. However, I'll rebase on the
3.6 pull request tag he sends for that branch as soon as it's available.
