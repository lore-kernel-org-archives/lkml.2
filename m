Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0H3M4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:56:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38456 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab0H3M4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:56:03 -0400
Date: Mon, 30 Aug 2010 14:55:56 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 3/3 v2] dmaengine: Add Freescale i.MX SDMA support
Message-ID: <20100830125556.GL1473@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <20100823174852.GB26928@pengutronix.de> <AANLkTimmEKfErV17RWNBO-pVCfFtFw=yJL2v92UBN0=2@mail.gmail.com> <201008281727.10913.marek.vasut@gmail.com> <20100828161858.GI1473@pengutronix.de> <AANLkTimhFAhR3sSJWo3b8_rMk5GCQfOwG0T36uEs=DjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimhFAhR3sSJWo3b8_rMk5GCQfOwG0T36uEs=DjA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:45:20 up 58 days,  3:56, 31 users,  load average: 0.21, 0.30,
	0.34
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 02:35:01PM +0200, Linus Walleij wrote:
> 2010/8/28 Sascha Hauer <s.hauer@pengutronix.de>:
> 
> > Peripherals integrated into a SoC like the SDMA engine here are
> > normally accessible in native endianess and thus need the __raw_*
> > functions.
> 
> So the SDMA actually switch and twist around the endianness of
> its registers if it's synthesized into a bigendian version of the system?
> 
> Or hardware-dynamically even depending on the setting of the
> endianness bit in the ARM core?

I think it's the bus between the ARM core and the periherals which
changes the endianess. I have never tried running an i.MX in big endian
mode, so I can only guess how the system really behaves in BE mode.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
