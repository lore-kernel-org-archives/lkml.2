Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2BUSq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:46:57 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:14221 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2BUSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:46:55 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19u1G9zsuOkKkfYZ0UbjLNA
Date: Tue, 21 Feb 2012 10:46:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Matt Porter <mporter@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120221184648.GR18185@atomide.com>
References: <1329151422-2146-1-git-send-email-mporter@ti.com>
 <20120213165209.GA31482@n2100.arm.linux.org.uk>
 <20120213165617.GE3494@opensource.wolfsonmicro.com>
 <20120213175233.GC1426@atomide.com>
 <20120213180236.GB31482@n2100.arm.linux.org.uk>
 <20120213181410.GE1426@atomide.com>
 <20120213185823.GF3494@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120213185823.GF3494@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@opensource.wolfsonmicro.com> [120213 10:27]:
> On Mon, Feb 13, 2012 at 10:14:10AM -0800, Tony Lindgren wrote:
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [120213 09:31]:
> > > On Mon, Feb 13, 2012 at 09:52:34AM -0800, Tony Lindgren wrote:
> 
> > > > Can't we just leave out the .id and have it automatically assigned?
> 
> It'd be nice but...
> 
> > > Unfortunately, there's no such infrastructure in the driver model.
> 
> > Hmm OK, -1 seems to be just used for name in platform_device_add().
> 
> -1 is a valid ID also, it means "there's only one of these things so
> don't display a number".  Which is sad but there we are.  I'm at ELC/ABS
> so I might try and find Greg in person here to see if we can come up
> with something better, it seems like this is something the core ought to
> be able to help with in much the same way that the USB stuff can.

Matt, care to refresh your original patch using some other number so
we can apply it as a regression fix for the -rc series while the
long term solution is being discussed?

Just use some random number for now with a comment, 42?

Regards,

Tony
