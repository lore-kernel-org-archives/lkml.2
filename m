Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab2AGOuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 09:50:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57380 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2AGOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 09:50:12 -0500
Date: Sat, 7 Jan 2012 15:50:08 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: Status of arm-soc.git for 3.2
Message-ID: <20120107145008.GG25978@pengutronix.de>
References: <201201032243.06440.arnd@arndb.de>
 <20120104100016.GK2914@n2100.arm.linux.org.uk>
 <201201062336.31181.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201201062336.31181.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 11:36:30PM +0000, Arnd Bergmann wrote:
> On Wednesday 04 January 2012, Russell King - ARM Linux wrote:
> > On Tue, Jan 03, 2012 at 10:43:06PM +0000, Arnd Bergmann wrote:
> > > The merge window is almost there, so it's time to look at what we've queued
> > > up in the arm-soc tree. There is a total of 55 branches with 386 non-merge
> > > changesets on top of mainline and the dependencies (linux-arm, v4l and
> > > dmaengine). The total diffstat is:
> > > 
> > >  676 files changed, 19694 insertions(+), 12633 deletions(-)
> > 
> > Well, my tree looks like this:
> >   937 files changed, 8150 insertions(+), 10774 deletions(-)
> >
> > > I would like to stop adding non-bugfix patches into the branches above now
> > > for 3.2, and instead merge everything that I receive from now on into
> > > late/* branches, so we don't destabilize the patches that are already there
> > > and so I can feel more comfortable about sending everything in the next/*
> > > branches upstream ASAP.
> > 
> > I think that's a must - for both our trees.  We have quite a number of
> > conflicts in linux-next between our trees and other trees - some of them
> > due to duplicated commits being applied.
> 
> Hmm, I'll have to check that, I was hoping that we manged to weed out
> the duplicated commits. Do you have a list, or some (semi-)automated
> way to find those, or are those just random commits you stumbled
> over.
You can look at

	git log --left-right --cherry-mark arm-soc...rmk ^linus/master | grep =

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
