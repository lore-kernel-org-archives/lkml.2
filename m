Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1BRIjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:39:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54526 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab1BRIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:39:41 -0500
Date: Fri, 18 Feb 2011 09:39:28 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 16/17] mc13xxx: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110218083928.GU22310@pengutronix.de>
References: <20110211181921.3d561568@queued.net>
 <20110216094154.GV13279@pengutronix.de>
 <20110216090036.6fffed34@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110216090036.6fffed34@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 09:00:36AM -0800, Andres Salomon wrote:
> On Wed, 16 Feb 2011 10:41:54 +0100
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> 
> > On Fri, Feb 11, 2011 at 06:19:21PM -0800, Andres Salomon wrote:
> > > 
> > > The cell's platform_data is now accessed with a helper function;
> > > change clients to use that, and remove the now-unused data_size.
> > > 
> > > Note that mfd-core no longer makes a copy of platform_data, but the
> > why was this changed and where?  I'm not able to find your complete
> > series via gmane.
> 
> http://permalink.gmane.org/gmane.linux.kernel/1099164
I still don't get the motivation of your patch set.  For drivers that
don't need the mfd_cells you introduce another level of indirection.
And drivers that want to use mfd_cells as platform_data, they can
already now.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
