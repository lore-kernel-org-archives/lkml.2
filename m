Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1K1Le7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:34:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45479 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab1K1Le6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:34:58 -0500
Date: Mon, 28 Nov 2011 11:34:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v2] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111128113455.GC2934@opensource.wolfsonmicro.com>
References: <1322224743-15671-1-git-send-email-tomoya.rohm@gmail.com>
 <20111125142858.GE5315@opensource.wolfsonmicro.com>
 <CANKRQnjf6x6GJhFoE+VYRG-=T=vtWDhNgjuED0zGcEEGDA7y0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQnjf6x6GJhFoE+VYRG-=T=vtWDhNgjuED0zGcEEGDA7y0A@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 06:44:04PM +0900, Tomoya MORINAGA wrote:
> 2011/11/25 Mark Brown <broonie@opensource.wolfsonmicro.com>: wrote

> >> +     SOC_SINGLE("Digital Volume Switch", ML26124_FILTER_EN, 4, 1, 0),

> > This needs either a Playback or Capture in there to match up with the
> > above unless it genuinely does mute both which would be really weird.

> Digital Volume Switch is used for both Playback and Capture.

That's *really* odd.  If that is the case it should probably just be
"Digital Switch" - having both Volume and Switch doesn't make any sense.
