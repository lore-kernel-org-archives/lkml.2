Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2BMSOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:14:20 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17759 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab2BMSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:14:16 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Nh8Tol+sevGGh1Bc9TYmu
Date: Mon, 13 Feb 2012 10:14:10 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Matt Porter <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120213181410.GE1426@atomide.com>
References: <1329151422-2146-1-git-send-email-mporter@ti.com>
 <20120213165209.GA31482@n2100.arm.linux.org.uk>
 <20120213165617.GE3494@opensource.wolfsonmicro.com>
 <20120213175233.GC1426@atomide.com>
 <20120213180236.GB31482@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213180236.GB31482@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [120213 09:31]:
> On Mon, Feb 13, 2012 at 09:52:34AM -0800, Tony Lindgren wrote:
> > * Mark Brown <broonie@opensource.wolfsonmicro.com> [120213 08:25]:
> > > On Mon, Feb 13, 2012 at 04:52:09PM +0000, Russell King - ARM Linux wrote:
> > > 
> > > > I think OMAP (or even the reg-fixed-voltage folk) needs to create an enum
> > > > similar to what I did for 8250 to control the allocation of platform
> > > > device IDs for this, otherwise we're going to keep on running over this
> > > > problem.
> > > 
> > > > Added Mark for his comment.
> > > 
> > > Hrm, seems slightly icky but the enum will work if we can decide how to
> > > add elements to the enum since it'll be easy to bloat a lot it if it's
> > > central.  It's tempting to suggest just using a random number to assign
> > > the IDs randomly rather than have a central registry but obviously
> > > there's no guarantees there.
> > 
> > Can't we just leave out the .id and have it automatically assigned?
> 
> Unfortunately, there's no such infrastructure in the driver model.

Hmm OK, -1 seems to be just used for name in platform_device_add().

Tony
