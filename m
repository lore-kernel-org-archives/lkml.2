Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab2CRQJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 12:09:04 -0400
Received: from imr3.ericy.com ([198.24.6.13]:48455 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab2CRQJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 12:09:00 -0400
Date: Sun, 18 Mar 2012 09:07:18 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Diego Elio =?iso-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
Message-ID: <20120318160718.GA26847@ericsson.com>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
 <20120317123151.AAF9A3E0952@localhost>
 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2012 at 07:53:42PM +0100, Diego Elio Pettenò wrote:
> Il giorno sab, 17/03/2012 alle 12.31 +0000, Grant Likely ha scritto:
> > Really?  The config line above claims IT8761E support.  How similar are
> > these devices?  Either this line needs to be more specifc, or the drivers
> > need to be merged.
> 
> I'm not sure about IT8761E, and it seems it's only partially the case
> from the code I read; it probably would be possible — Denis would you
> mind taking a look?
> 
> It could possibly work to merge them. For what it's worth I've more or
> less followed on the steps of the two watchdog timer drivers for IT87
> series.
> 
I don't think that would make sense. IT8761E has a completely different set
of registers. It is a "Legacy Low Pin Count I/O" only. The other chips are
environmental control chips. I didn't follow the context of this discussion,
but IT8761E does not support a watchdog. It also only supports 16 GPIO pins.

Guenter
