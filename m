Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1LLKF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:05:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35150 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1LLKF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:05:27 -0500
Date: Mon, 12 Dec 2011 10:05:14 +0000
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
Message-ID: <20111212100513.GA5017@sirena.org.uk>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <1321848532-8784-3-git-send-email-tomoya.rohm@gmail.com>
 <20111121114524.GE3784@opensource.wolfsonmicro.com>
 <CANKRQnivyNXNZPnaUOHwpXpJz+kCz6gOwfqYNwkcOo5EpsSvZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnivyNXNZPnaUOHwpXpJz+kCz6gOwfqYNwkcOo5EpsSvZQ@mail.gmail.com>
X-Cookie: Where does it go when you flush?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 05:28:13PM +0900, Tomoya MORINAGA wrote:

> struct snd_soc_ops {
> ...
> };

> On the other hand, tegra_i2s.c describes like below.

> static const struct snd_soc_dai_ops tegra_i2s_dai_ops = {
> ...
> };

> Which is true as modern driver ? or case by case ?

The latter.  With things like this it would be *really* helpful if you
could take a step back and think about what the differences mean and why
they are different.

> 
> >> +#define      I2S_CH0_MCLK            (12288000) /* Master Clock Frequency[Hz] */
> > This looks like it should be board specific?
> Should our platform driver use "clk_get()" ?
> If no, how should our driver get the value ?

Again, with things like this it would be really helpful if you could
attempt to answer questions for yourself.  Have you looked at how other
platforms configure clock rates from machine drivers?
