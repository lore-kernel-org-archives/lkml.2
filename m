Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2FKHF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:05:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39775 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2FKHF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:05:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120601083018.GH24139@opensource.wolfsonmicro.com>
References: <CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
	<20120524100742.GH5361@opensource.wolfsonmicro.com>
	<CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
	<1337941231.1580.19.camel@vkoul-udesk3>
	<20120527221956.GB25019@opensource.wolfsonmicro.com>
	<CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
	<20120530121449.GI9947@opensource.wolfsonmicro.com>
	<CANKRQni4uqQJ99ycOScHmn-g1kz2_XH7ePL+n1taG5jAbDSubw@mail.gmail.com>
	<20120531104538.GA2666@opensource.wolfsonmicro.com>
	<CANKRQnjdiV+e=N+n_ZP04jmCAhxKjgZ+wab+anbgO+VJPNo=PQ@mail.gmail.com>
	<20120601083018.GH24139@opensource.wolfsonmicro.com>
Date: Mon, 11 Jun 2012 16:05:56 +0900
Message-ID: <CANKRQnjeYtBucmGoDUg7oTK82rvnkakWRB0Siezyz-kbhyPC+g@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, alsa-devel@alsa-project.org,
        lars@metafoo.de, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 5:30 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> > Sorry, I couldn't find.
> > Is your saying Linus's tree this ?
> > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > However, any ASoC driver doesn't use cyclic DMA's.
>
> $ grep CYCLIC sound/soc/soc-dmaengine-pcm.c
>        dma_cap_set(DMA_CYCLIC, mask);

I already saw this.

You said "all current mainline drivers using the library use cyclic DMA."
Does this mean the following drivers use "snd_dmaengine_pcm_open" ?
  ep93xx-pcm
  imx-pcm-dma-mx2
  mxs-pcm

However, the following drivers don't use any ASoC DMA framework, right ?.
E.g. these drivers call dma_request_channel directly.
  siu_pcm
  fsi
  txx9aclc

That is to say, some drivers ASoC DMA framework. However some drivers
don't use any ASoC DMA framework.

Why didn't you do porting to your saying "ASoC DMA framework"?

thanks.

--
ROHM Co., Ltd.
tomoya
