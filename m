Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882Ab1LMFAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 00:00:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab1LMFAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 00:00:05 -0500
Date: Tue, 13 Dec 2011 12:59:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mike Frysinger <vapier@gentoo.org>, qi.wang@intel.com,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        Daniel Mack <zonque@gmail.com>, Liam Girdwood <lrg@ti.com>,
        joel.clark@intel.com
Subject: Re: [alsa-devel] [PATCH 3/3] sound/soc/lapis: add platform driver
Message-ID: <20111213045958.GC4565@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <1321848532-8784-3-git-send-email-tomoya.rohm@gmail.com>
 <20111121114524.GE3784@opensource.wolfsonmicro.com>
 <CANKRQnivyNXNZPnaUOHwpXpJz+kCz6gOwfqYNwkcOo5EpsSvZQ@mail.gmail.com>
 <20111212100513.GA5017@sirena.org.uk>
 <CANKRQng7AgKLYGSbBMbOiWifL6WNPHM=b7cB0FhfuXg74qi1Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQng7AgKLYGSbBMbOiWifL6WNPHM=b7cB0FhfuXg74qi1Fg@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 01:38:25PM +0900, Tomoya MORINAGA wrote:
> 2011/12/12 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > The latter.  With things like this it would be *really* helpful if you
> > could take a step back and think about what the differences mean and why
> > they are different.

> Our driver needs ".pointer" method.
> However, "struct snd_soc_dai_ops" doesn't have the method.
> So, I think "struct snd_soc_dai_ops" cannot be applied to our driver.

What makes you claim this - *why* does your DAI driver need a pointer
method?

> Searching other drivers, "blackfin/bf5xx-i2s-pcm.c" uses "struct
> snd_soc_ops" not "struct snd_soc_dai_ops".
> Let me know your opinion.

Of course the DMA driver uses the ops for DMA drivers!  Alternatively if
your question above is about your DMA driver then why is your DMA driver
using DAI ops?

To repeat what I said above in a different way *please* put more effort
into understanding things and trying to solve problems for yourself, or
improving the way you ask questions.
