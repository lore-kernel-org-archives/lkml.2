Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1LBMWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:22:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55496 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419Ab1LBMWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:22:08 -0500
Date: Fri, 2 Dec 2011 12:22:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] sound/soc/lapis: add machine driver
Message-ID: <20111202122205.GL8245@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
 <1321848532-8784-2-git-send-email-tomoya.rohm@gmail.com>
 <20111121113433.GD3784@opensource.wolfsonmicro.com>
 <CANKRQnjdS1NvcGLa=S1M0D4U_NV3+JR1E4YfAV7Ziq-fE2LQgg@mail.gmail.com>
 <20111202114638.GI8245@opensource.wolfsonmicro.com>
 <CANKRQng5OzqjiQ81OUH+2Aet8DAM198s6B=_1FuASnd19BU26w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQng5OzqjiQ81OUH+2Aet8DAM198s6B=_1FuASnd19BU26w@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 09:09:34PM +0900, Tomoya MORINAGA wrote:
> 2011/12/2 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > The CPU side audio drivers are not there - there seemed to be some quite
> > serious review issues with those.

> Let me clarify your saying.
> Does the above "audio drivers" mean i2s (of south bridge) driver or HD
> audio (of north bridge) or another?

I2S and audio DMA.
