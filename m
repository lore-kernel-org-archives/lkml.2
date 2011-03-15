Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1COIeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:34:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54592 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1COIeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:34:16 -0400
Date: Tue, 15 Mar 2011 09:33:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Andres Salomon <dilinger@queued.net>, Sascha Hauer <kernel@pengutronix.de>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: mx51_efika: update platform data for new mfd
 changes
Message-ID: <20110315083358.GI29521@pengutronix.de>
References: <20110304080653.3f2c3f19@debxo>
 <20110307085358.GM29521@pengutronix.de>
 <20110311204405.GE20247@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311204405.GE20247@sortiz-mobl>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:32:38 up 26 days, 20:29, 33 users,  load average: 0.36, 0.80,
 0.51
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi samuel,

On Fri, Mar 11, 2011 at 09:44:05PM +0100, Samuel Ortiz wrote:
> Hi Sascha,
> 
> On Mon, Mar 07, 2011 at 09:53:58AM +0100, Sascha Hauer wrote:
> > On Fri, Mar 04, 2011 at 08:06:53AM -0800, Andres Salomon wrote:
> > > Note that this relies on stuff currently in mfd's next tree, but this
> > > is also a newer driver.  I'm not sure which tree it should go through,
> > > as it's a problem that shows up in next.
> > 
> > Please ping me again when the mfd tree is in Linus master. I see no
> > other chance fixing this on my side other than removing regulator
> > support for efika completely for now. So I guess you have to live with
> > the compile breakage for some time.
> It would probably make sense for me to carry this driver then. Sascha, would
> you be ok with it ? If that's so, could you please point me at a git commit
> from your tree ?

The file which is changed only got created in my tree, so no way for you
to apply it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
