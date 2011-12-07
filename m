Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1LGNYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:24:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43003 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755645Ab1LGNYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:24:44 -0500
Date: Wed, 7 Dec 2011 13:23:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH v2] soc/lapis: add machine driver
Message-ID: <20111207132322.GA18837@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
 <20111202153401.GX8245@opensource.wolfsonmicro.com>
 <CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
 <20111205183223.GB7467@opensource.wolfsonmicro.com>
 <CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
 <CANKRQnhbBNDjQw5MQGexZAEboC0oHB5QS1LfHo6pDeoeDSwByw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQnhbBNDjQw5MQGexZAEboC0oHB5QS1LfHo6pDeoeDSwByw@mail.gmail.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 01:42:45PM +0900, Tomoya MORINAGA wrote:
> 2011/12/6 Tomoya MORINAGA <tomoya.rohm@gmail.com>:

You're complaining that you didn't a response within 24 hours!  This is
really not reasonable for something which is essentially volunteer
driven project.

> > You said "Use the dai_fmt field in the dai_link to set this."
> > However, both dai_fmt and dai_link are already implemented like below.
> > static struct snd_soc_dai_link ioh_i2s_dai = {

> > static struct snd_soc_card ioh_i2s_card = {
> > ...
> >        .dai_link       = &ioh_i2s_dai,
> > ...
> > };

> > So, I can't understand your saying.

> Could you give me your answer ?

Your above code has no references to dai_fmt.  Have you looked at the
dai_fmt field in the dai_link structure or at the existing examples of
its use?
