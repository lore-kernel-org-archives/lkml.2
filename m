Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0LJPOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:14:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44298 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab0LJPOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:14:02 -0500
Date: Fri, 10 Dec 2010 16:14:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typos concerning "consistent"
Message-ID: <20101210151400.GN17441@pengutronix.de>
References: <1291989342-15763-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LNX.2.00.1012101604350.15140@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1012101604350.15140@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 04:05:06PM +0100, Jiri Kosina wrote:
> On Fri, 10 Dec 2010, Uwe Kleine-König wrote:
> 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  arch/arm/mach-msm/include/mach/entry-macro-qgic.S  |    2 +-
> >  arch/m68k/mac/psc.c                                |    2 +-
> >  drivers/net/via-velocity.c                         |    2 +-
> >  drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
> >  drivers/scsi/megaraid/megaraid_mm.c                |    2 +-
> >  drivers/staging/cxt1e1/hwprobe.c                   |    2 +-
> >  drivers/staging/cxt1e1/pmcc4.h                     |    2 +-
> >  drivers/staging/cxt1e1/pmcc4_drv.c                 |    2 +-
> >  .../staging/tidspbridge/include/dspbridge/drv.h    |    2 +-
> >  fs/jbd/transaction.c                               |    2 +-
> >  fs/jbd2/transaction.c                              |    2 +-
> >  net/ipv6/af_inet6.c                                |    2 +-
> >  12 files changed, 12 insertions(+), 12 deletions(-)
> 
> I have separated out the staging bits (please submit those to Greg), and 
> applied the rest.
Oh, I forgot that again, sorry.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
