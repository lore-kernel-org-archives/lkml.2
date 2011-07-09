Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1GIKXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 06:23:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40804 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1GIKXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 06:23:39 -0400
Date: Sat, 9 Jul 2011 11:23:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
Message-ID: <20110709102337.GD9247@sirena.org.uk>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com> <BANLkTi=r=N5OwfsVLRuBsNRSpv91pTgeKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=r=N5OwfsVLRuBsNRSpv91pTgeKA@mail.gmail.com>
X-Cookie: Oh Dad!  We're ALL Devo!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 01:57:36PM -0600, Grant Likely wrote:
> On Mon, Jun 13, 2011 at 10:58 AM, Linus Walleij

> > +This get/enable/disable/put sequence can just as well be handled by bus drivers
> > +if you don't want each and every driver to handle it and you know the
> > +arrangement on your bus.

> I would *strongly* recommend against individual device drivers
> accessing the pinmux api.  This is system level configuration code,
> and should be handled at the system level.

There can also be advantages to putting the pin into the designed mode
without the driver being loaded from the electrical point of view.  For
example, selecting appropriate pull values for pads can cut down on
power consumption.
