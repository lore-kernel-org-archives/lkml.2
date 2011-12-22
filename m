Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1LVKuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:50:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40831 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab1LVKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:50:04 -0500
Date: Thu, 22 Dec 2011 10:50:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3 v5] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20111222104959.GB4546@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
 <20111220104047.GE2866@opensource.wolfsonmicro.com>
 <CANKRQngonz+kV3e8tHjvjub-7Pp_5ejqk89Mk7c+Rop9J+_WvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQngonz+kV3e8tHjvjub-7Pp_5ejqk89Mk7c+Rop9J+_WvA@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 05:31:08PM +0900, Tomoya MORINAGA wrote:
> 2011/12/20 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > How have you tested this code?

> No, I haven't tested at all. (Of course, I tested before ASoC.)
> I'll test the new these drivers after you say "Roughly, how to use
> ASoC framework is OK"

Don't do this unless you really have to, and if for some reason it's
needed or useful then indicate that this is what you're doing.  People
shouldn't be finding issues on review that mean that the code will never
run.  If the testing is very light that's fine but you need to make some
effort to verify that things will work.
