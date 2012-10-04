Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab2JDOGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:06:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41358 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab2JDOGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:06:23 -0400
Date: Thu, 4 Oct 2012 16:06:09 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Matt Porter <mporter@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/6] uio_pruss cleanup and platform support
Message-ID: <20121004140609.GA5464@pengutronix.de>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
 <20121004091145.GA3317@pengutronix.de>
 <20121004124253.GC11149@beef>
 <20121004133553.GA5151@pengutronix.de>
 <20121004135433.GI11149@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004135433.GI11149@beef>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:03:48 up  6:32, 11 users,  load average: 0.14, 0.07, 0.06
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 09:54:33AM -0400, Matt Porter wrote:
> *sigh*, I see now. I looked at v2 and got wrapped up in the DT use case
> and missed your platform device support. I think it will work just fine
> for us to use in a "phase 2" of this work, replacing the backend of
> davinci sram allocation with this as Sekhar seems to be open to. 
> 
> > > I do see it moving to your driver exclusively, but I wanted to make this
> > > series focused on only getting rid of the private SRAM API using the
> > > existing pdata framework that's already there. I think once
> > > gen_pool_find_by_phys() goes upstream we can switch to that and get the
> > > address from a resource in the !DT case. I guess we should see if Sekhar
> > > would like to see this happen in two steps or just have us depend on
> > > the gen_pool_find_by_phys() patch now.
> > 
> > Thanks, I'm glad you are aware of the sram driver and consider it useful.
> > 
> > > BTW, I was going to post a patch for your driver to allow
> > > configurability of the allocation order, but have been busy with other
> > > things.  We'll eventually need that when switching to it as the
> > > hardcoded page size order isn't going to work for all cases.
> > 
> > Good point.
> 
> I think this is the only blocker to DaVinci adopting it once it goes
> upstream. I can add a patch in your driver thread if that helps.

Yes, that would be welcome.

regards
Philipp

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
