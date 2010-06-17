Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab0FQJTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:19:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:55593 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab0FQJTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:19:52 -0400
Date: Thu, 17 Jun 2010 11:19:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] trivial: fix typos concerning "precedence"
In-Reply-To: <20100617050626.GA12695@pengutronix.de>
Message-ID: <alpine.LNX.2.00.1006171119360.12271@pobox.suse.cz>
References: <20100611101624.GD10894@pengutronix.de> <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LNX.2.00.1006161804150.12271@pobox.suse.cz> <20100617050626.GA12695@pengutronix.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Uwe Kleine-König wrote:

> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > ---
> > >  arch/sh/kernel/clkdev.c                  |    2 +-
> > >  drivers/staging/comedi/drivers/usbdux.c  |    2 +-
> > >  drivers/staging/octeon/cvmx-cmd-queue.c  |    6 +++---
> > >  drivers/staging/pohmelfs/inode.c         |    2 +-
> > >  drivers/staging/rt2860/common/cmm_wpa.c  |    4 ++--
> > >  drivers/staging/rtl8192e/r8190_rtl8256.c |    6 +++---
> > 
> > Hi,
> > 
> > please send the staging parts separately to Greg (you did it for other 
> > patches, but likely forgot for this one).
> I didn't forget it but messed up the splitting.  Note patch 6 touches
> staging, too.

Yeah, I have already dropped the staging part of that one.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
