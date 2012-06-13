Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2FMKmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:42:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59991 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2FMKl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:41:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120611085404.GB11439@opensource.wolfsonmicro.com>
References: <CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
	<1337941231.1580.19.camel@vkoul-udesk3>
	<20120527221956.GB25019@opensource.wolfsonmicro.com>
	<CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
	<20120530121449.GI9947@opensource.wolfsonmicro.com>
	<CANKRQni4uqQJ99ycOScHmn-g1kz2_XH7ePL+n1taG5jAbDSubw@mail.gmail.com>
	<20120531104538.GA2666@opensource.wolfsonmicro.com>
	<CANKRQnjdiV+e=N+n_ZP04jmCAhxKjgZ+wab+anbgO+VJPNo=PQ@mail.gmail.com>
	<20120601083018.GH24139@opensource.wolfsonmicro.com>
	<CANKRQnjeYtBucmGoDUg7oTK82rvnkakWRB0Siezyz-kbhyPC+g@mail.gmail.com>
	<20120611085404.GB11439@opensource.wolfsonmicro.com>
Date: Wed, 13 Jun 2012 19:41:57 +0900
Message-ID: <CANKRQngP3e3U+VZDgA7fQfxBti9vri-AEAR8iTmhLYiqXP_kiw@mail.gmail.com>
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

On Mon, Jun 11, 2012 at 5:54 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> There are some drivers that predate the availibility of the dmaengine
> framework.

In case, you develop a new ASoC framework,  all previous ASoC drivers
should be adopted to the framework by yourself, don't you ?
Because a new developer must be confused by this.

> This, and the fact that the PCH driver uses dmaengine without using any
> shared code, is the topic of the discussion.  It is entirely natural
> that there are no open coded drivers using cyclic DMA via dmaengine,
> they have all had that code factored out.
>
> Please stop this and at least look at factoring this code out.  If it
> turns out that there's some reason why it's a lot of work that's one
> thing but it seems clear that you've not even looked yet.  It's like the
> previous issues where you were sending patches which would clearly not
> run successfully, it's not a very positive approach.

OK, I'll stop this.

I wanted to finish adding these patch series to upstream because we
spent much resource on this.
But I'm involved in other work, so I can't start now.

Until now thank you for your support.
Regards.

-- 
ROHM Co., Ltd.
tomoya
