Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab2GCGec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:34:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7662 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933435Ab2GCGeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:34:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 02 Jul 2012 23:33:33 -0700
Message-ID: <4FF2914B.1000601@nvidia.com>
Date: Tue, 3 Jul 2012 11:59:31 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "perex@perex.cz" <perex@perex.cz>,
        Stephen Warren <swarren@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com> <1340969673-7776-2-git-send-email-ldewangan@nvidia.com> <4FF1D083.7060207@wwwdotorg.org>
In-Reply-To: <4FF1D083.7060207@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,
On Monday 02 July 2012 10:16 PM, Stephen Warren wrote:
> On 06/29/2012 05:34 AM, Laxman Dewangan wrote:
>> Use the dmaengine based Tegra APB DMA driver for
>> data transfer between SPI fifo and memory in
>> place of legacy Tegra APB DMA.
>>
>> Because generic soc-dmaengine-pcm uses the DMAs API
>> based on dmaengine, using the exported APIs provided
>> by this generic driver.
>>
>> The new driver is selected if legacy driver is not
>> selected and new dma driver is enabled through config
>> file.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Acked-by: Stephen Warren<swarren@wwwdotorg.org>
> Tested-by: Stephen Warren<swarren@wwwdotorg.org>
>
> (Tested on Cardhu/Tegra30. It fails on Whistler/Tegra20, but I assume
> that's due to a bug in the dmaengine driver not this patch. There won't
> be a regression when applying this patch since we haven't switched to
> dmaengine as the default yet).

Are you taking this patch?
I have other independent patch for the writecombine dma support in pcm 
memory library and wanted to avoid any merge conflicts.
So if it goes in your tree then the other patch also need to go in your 
tree.

