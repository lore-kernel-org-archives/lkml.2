Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab2BMSCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:02:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42820 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab2BMSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:02:50 -0500
Date: Mon, 13 Feb 2012 18:02:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Matt Porter <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
	regulators
Message-ID: <20120213180236.GB31482@n2100.arm.linux.org.uk>
References: <1329151422-2146-1-git-send-email-mporter@ti.com> <20120213165209.GA31482@n2100.arm.linux.org.uk> <20120213165617.GE3494@opensource.wolfsonmicro.com> <20120213175233.GC1426@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213175233.GC1426@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 09:52:34AM -0800, Tony Lindgren wrote:
> * Mark Brown <broonie@opensource.wolfsonmicro.com> [120213 08:25]:
> > On Mon, Feb 13, 2012 at 04:52:09PM +0000, Russell King - ARM Linux wrote:
> > 
> > > I think OMAP (or even the reg-fixed-voltage folk) needs to create an enum
> > > similar to what I did for 8250 to control the allocation of platform
> > > device IDs for this, otherwise we're going to keep on running over this
> > > problem.
> > 
> > > Added Mark for his comment.
> > 
> > Hrm, seems slightly icky but the enum will work if we can decide how to
> > add elements to the enum since it'll be easy to bloat a lot it if it's
> > central.  It's tempting to suggest just using a random number to assign
> > the IDs randomly rather than have a central registry but obviously
> > there's no guarantees there.
> 
> Can't we just leave out the .id and have it automatically assigned?

Unfortunately, there's no such infrastructure in the driver model.
