Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2GBQrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:47:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52141 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2GBQrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:47:03 -0400
Message-ID: <4FF1D083.7060207@wwwdotorg.org>
Date: Mon, 02 Jul 2012 10:46:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>,
        broonie@opensource.wolfsonmicro.com
CC: tiwai@suse.de, perex@perex.cz, swarren@nvidia.com, lrg@ti.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com> <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340969673-7776-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 05:34 AM, Laxman Dewangan wrote:
> Use the dmaengine based Tegra APB DMA driver for
> data transfer between SPI fifo and memory in
> place of legacy Tegra APB DMA.
> 
> Because generic soc-dmaengine-pcm uses the DMAs API
> based on dmaengine, using the exported APIs provided
> by this generic driver.
> 
> The new driver is selected if legacy driver is not
> selected and new dma driver is enabled through config
> file.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>

(Tested on Cardhu/Tegra30. It fails on Whistler/Tegra20, but I assume
that's due to a bug in the dmaengine driver not this patch. There won't
be a regression when applying this patch since we haven't switched to
dmaengine as the default yet).
