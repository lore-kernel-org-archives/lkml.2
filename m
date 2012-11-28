Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2K1OAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:00:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41782 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2K1OAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:00:00 -0500
Date: Wed, 28 Nov 2012 13:59:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Oskar Schirmer <oskar@scara.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Liam Girdwood <lrg@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Zeng Zhaoming <zengzm.kernel@gmail.com>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] sound/sgtl5000: fix initial setting for DAC data source
Message-ID: <20121128135953.GA22582@sirena.org.uk>
References: <50B5E03E.2080308@ti.com>
 <1354097668-3780-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354097668-3780-1-git-send-email-oskar@scara.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:14:28AM +0000, Oskar Schirmer wrote:

You've somehow decided to CC half the world but still haven't managed
to CC the maintainers like Liam asked (and as is covered in
SubmittingPatches)...

> According to documentation bit 3:2 in register SSS_CTRL are
> reserved and zero, so the setting of 0x0008 does not make much sense.
> Instead, bit 4 should be set as is with power up, to reflect
> routing of I2S_IN to DAC correctly.

> Looks much like an off by one error.

What does "as is with power up" mean?  This is a register defaults
table, it should reflect what is in the register defaults.  The meaning
of the field and the desired configuration for runtime is not relevant
here, the only thing that matters is what the default value of the
register is.
