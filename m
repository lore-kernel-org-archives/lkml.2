Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0FQFG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 01:06:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32788 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0FQFG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 01:06:28 -0400
Date: Thu, 17 Jun 2010 07:06:27 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] trivial: fix typos concerning "precedence"
Message-ID: <20100617050626.GA12695@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de> <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LNX.2.00.1006161804150.12271@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1006161804150.12271@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:04:42PM +0200, Jiri Kosina wrote:
> On Fri, 11 Jun 2010, Uwe Kleine-König wrote:
> 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  arch/sh/kernel/clkdev.c                  |    2 +-
> >  drivers/staging/comedi/drivers/usbdux.c  |    2 +-
> >  drivers/staging/octeon/cvmx-cmd-queue.c  |    6 +++---
> >  drivers/staging/pohmelfs/inode.c         |    2 +-
> >  drivers/staging/rt2860/common/cmm_wpa.c  |    4 ++--
> >  drivers/staging/rtl8192e/r8190_rtl8256.c |    6 +++---
> 
> Hi,
> 
> please send the staging parts separately to Greg (you did it for other 
> patches, but likely forgot for this one).
I didn't forget it but messed up the splitting.  Note patch 6 touches
staging, too.

I will resend these two later today.

Sorry
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
