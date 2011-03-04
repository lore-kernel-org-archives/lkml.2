Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab1CDTqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:46:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41764 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703Ab1CDTqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:46:34 -0500
Date: Fri, 4 Mar 2011 20:46:16 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andres Salomon <dilinger@queued.net>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mx51_efika: update platform data for new mfd
 changes
Message-ID: <20110304194616.GW22310@pengutronix.de>
References: <20110304080653.3f2c3f19@debxo>
 <4D710FF9.6040305@ru.mvista.com>
 <20110304083822.0f40d120@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110304083822.0f40d120@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:38:22AM -0800, Andres Salomon wrote:
> On Fri, 04 Mar 2011 19:14:49 +0300
> Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> 
> > Hello.
> > 
> > Andres Salomon wrote:
> > 
> > > Note that this relies on stuff currently in mfd's next tree, but
> > > this is also a newer driver.  I'm not sure which tree it should go
> > > through, as it's a problem that shows up in next.
> > 
> >     This passage should be under --- tear line.
> 
> What?
Actually putting it above the commit log and separating it by a scissors
line (see git-mailinfo(1), git am -c) should be fine, too.

This is all about selecting which part of the message should end up in
the commit log.  Git ignores everything after the tripple dash (apart
from the patch of course).

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
