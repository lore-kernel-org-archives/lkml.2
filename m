Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2F1MKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:10:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11805 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2F1MKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:10:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 28 Jun 2012 05:06:52 -0700
Message-ID: <4FEC48FF.9040408@nvidia.com>
Date: Thu, 28 Jun 2012 17:37:27 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lrg@ti.com" <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com> <20120628105148.GD28922@opensource.wolfsonmicro.com> <4FEC468A.3080607@nvidia.com> <20120628120245.GF28922@opensource.wolfsonmicro.com>
In-Reply-To: <20120628120245.GF28922@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 05:32 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Jun 28, 2012 at 05:26:58PM +0530, Laxman Dewangan wrote:
>
>> Other driver which can use this API are davinci, OMAP, samsung but
>> because they are not using the snd_dmaengine_pcm driver's api as of
>> now so not be very much useful for them.
> There's no reason why we can't factor out more common code - this is
> essentially what Lars-Peter was saying.
>

Ok, then let me start on this.

>> Should I send one patch per driver change or squash all 4 file
>> changes in one patch? Whatever will be easy or recommended?
> It doesn't really matter that much, but please take on board
> Lars-Peter's comments.

Ok then I will go for one patch per file.
I will send the patches in series.

