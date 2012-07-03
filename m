Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab2GCGa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:30:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7331 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab2GCGas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:30:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jul 2012 23:30:45 -0700
Message-ID: <4FF290A1.6060603@nvidia.com>
Date: Tue, 3 Jul 2012 11:56:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, "tiwai@suse.de" <tiwai@suse.de>,
        "perex@perex.cz" <perex@perex.cz>, Stephen Warren <swarren@nvidia.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ASoC: tegra: use dmaengine based dma driver
References: <1340969673-7776-1-git-send-email-ldewangan@nvidia.com> <1340969673-7776-2-git-send-email-ldewangan@nvidia.com> <4FEDDF89.1050907@wwwdotorg.org> <4FEF166D.2010705@nvidia.com> <4FF15B16.9020903@nvidia.com> <4FF1D00D.6040402@wwwdotorg.org> <20120702164717.GH25093@opensource.wolfsonmicro.com>
In-Reply-To: <20120702164717.GH25093@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012 10:17 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jul 02, 2012 at 10:45:01AM -0600, Stephen Warren wrote:
>
>> to work. No audio is heard, and aplay eventually exits with the
>> following error message:
> For values of eventually that will be about 10s by default.
>
>> aplay: pcm_write:1603: write error: Input/output error
>> I believe this means that the DMA simply isn't operating.
> Yes, normally.

Let me debug this specific to T20 but it will not stop to apply the patch.

