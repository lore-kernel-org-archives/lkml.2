Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1DEDGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:06:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40943 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1DEDFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:05:52 -0400
Date: Mon, 4 Apr 2011 21:05:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-mmc@vger.kernel.org, Daniel Ribeiro <drwyrm@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Chris Ball <cjb@laptop.org>, Ernst Schwab <eschwab@online.de>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        openezx-devel@lists.openezx.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mmc_spi: Add support for regulator framework
Message-ID: <20110405030543.GC29522@ponder.secretlab.ca>
References: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
 <20110404115631.67b1f317.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110404115631.67b1f317.ospite@studenti.unina.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 11:56:31AM +0200, Antonio Ospite wrote:
> On Mon, 21 Mar 2011 19:46:38 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
> > Hi,
> > 
> > this patchset has the purpose of adding support for the regulator framework to 
> > the mmc_spi driver. The first three patches are preparatory cleanups to make 
> > the fourth one more straightforward.
> > 
> > Maybe the fourth patch can be improved, I am open to any suggestions about it.
> >
> 
> Ping. I forgot to Cc spi-devel-general on this series, should I resend
> it?

Not a bad idea.  It doesn't go via my tree since it is an mmc patch,
not an spi one, but I don't mind taking a look at the spi bits.

g.

> 
> > These changes take strong inspiration from the pxamci driver; they have been 
> > tested on a Motorola A910, which uses a regulator to powerup the MMC card 
> > connected to the SPI bus, a test from a current user of the mmc_spi driver 
> > would not hurt just to be sure no regressions have been introduced.
> > 
> > Thanks,
> >    Antonio
> > 
> > Antonio Ospite (4):
> >   mmc_spi.c: factor out the check for power capability
> >   mmc_spi.c: factor out the SD card shutdown sequence
> >   mmc_spi.c: factor out a mmc_spi_setpower() function
> >   mmc_spi.c: add support for the regulator framework
> > 
> >  drivers/mmc/host/mmc_spi.c |  194 +++++++++++++++++++++++++++++---------------
> >  1 files changed, 129 insertions(+), 65 deletions(-)
> > 
> 
> -- 
> Antonio Ospite
> http://ao2.it
> 
> PGP public key ID: 0x4553B001
> 
> A: Because it messes up the order in which people normally read text.
>    See http://en.wikipedia.org/wiki/Posting_style
> Q: Why is top-posting such a bad thing?


