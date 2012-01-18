Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2ARLth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:49:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55777 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2ARLtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:49:36 -0500
Date: Wed, 18 Jan 2012 12:49:33 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 2/3] i2c: Add Congatec CGEB I2C driver
Message-ID: <20120118114933.GC5446@pengutronix.de>
References: <1326727940-6078-1-git-send-email-s.hauer@pengutronix.de>
 <1326727940-6078-3-git-send-email-s.hauer@pengutronix.de>
 <20120116222123.0396f4dd@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116222123.0396f4dd@endymion.delvare>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:48:00 up 66 days, 19:35, 23 users,  load average: 0.00, 0.38,
 1.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 10:21:23PM +0100, Jean Delvare wrote:
> Hi Sascha,
> 
> On Mon, 16 Jan 2012 16:32:19 +0100, Sascha Hauer wrote:
> > This driver provides a I2C bus driver for the CGEB interface
> > found on some Congatec x86 modules. No devices are registered
> > on the bus, the user has to do this via the i2c device /sys
> > interface.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/i2c/busses/Kconfig             |    7 +
> >  drivers/i2c/busses/Makefile            |    1 +
> >  drivers/i2c/busses/i2c-congatec-cgeb.c |  206 ++++++++++++++++++++++++++++++++
> >  3 files changed, 214 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/i2c/busses/i2c-congatec-cgeb.c
> > (...)
> 
> This should be sent to the linux-i2c list for review.

Yes, it was my intention to do this. Somehow I also forgot the watchdog
list. I Will send it there, I just hoped to get some comment to the base
driver first.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
