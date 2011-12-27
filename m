Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1L0Rde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:33:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40720 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754721Ab1L0Rdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:33:31 -0500
Date: Tue, 27 Dec 2011 17:33:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3 v2] sound/soc/lapis: add platform driver for ML7213
 IOH I2S
Message-ID: <20111227173326.GC22970@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
 <1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
 <20111220132314.GQ2866@opensource.wolfsonmicro.com>
 <CANKRQng8N3oS2o17HPUZeonXB3KLBK9oNQj-zd9+aUUvWcTo0A@mail.gmail.com>
 <20111222005816.GB27144@opensource.wolfsonmicro.com>
 <CANKRQnjCTAX02wJt7StjB0rXkg3Q6bPBRYCbkgq6vS5NFd97Fg@mail.gmail.com>
 <20111222103946.GA4546@opensource.wolfsonmicro.com>
 <CANKRQng+H4NxaSLpZpYOCT-CdovxbToT-waz0JNMFT2AcD_gvA@mail.gmail.com>
 <20111226121207.GF8722@opensource.wolfsonmicro.com>
 <CANKRQnhJhpwhGywGz=r0tVF0k+eWb4vrGkdVD9NdzRFNo9PNtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQnhJhpwhGywGz=r0tVF0k+eWb4vrGkdVD9NdzRFNo9PNtA@mail.gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 10:25:25AM +0900, Tomoya MORINAGA wrote:
> 2011/12/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > So you're just talking about standard underflows if the application
> > can't keep up?

> No. not only underflow but overflow.

Same difference.

> > There's *no* reason for your driver to do anything about
> > this, it's a really basic thing that affects all audio hardware.  Just
> > write a driver for the hardware.

> In case driver layer doesn't have the function,
> which part works for the under/overflow ? Application ? or nothing ?

Your driver has to accurately describe what the hardware supports and
then the application layer is responsible for making sure it keeps up
with things.
