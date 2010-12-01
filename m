Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0LANDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:03:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50570 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0LANDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:03:24 -0500
Date: Wed, 1 Dec 2010 13:02:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Stuge <peter@stuge.se>
Cc: Greg KH <greg@kroah.com>, Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Message-ID: <20101201130248.GA21710@n2100.arm.linux.org.uk>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <201011261224.59490.arnd@arndb.de> <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com> <201011301621.48140.arnd@arndb.de> <20101130184049.GC8521@n2100.arm.linux.org.uk> <20101130184834.GA16055@kroah.com> <20101130220550.GD8521@n2100.arm.linux.org.uk> <20101130230533.GA11342@kroah.com> <20101130234215.GE8521@n2100.arm.linux.org.uk> <20101201125339.30270.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201125339.30270.qmail@stuge.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 01:53:39PM +0100, Peter Stuge wrote:
> Russell King - ARM Linux wrote:
> > I feel it would be better to allow the current situation to continue.
> 
> I think this misses the point, and is somewhat redundant; I think
> everyone knows that it is easiest to never change anything. But
> then nothing improves.
> 
> 
> > If we start telling people that they can't use statically declared
> > devices without first having an alternative,
> 
> I would consider it early warning that the way things have been done
> before will go away. And I would thus write drivers in a way that
> demonstrates and includes that understanding.

Clearly you haven't understood my point.

If we go down the route you suggest, we're going to end up with
everyone doing something different, which will then need to be cleaned
up once the proper solution is in place.  That could easily become
much more work than just waiting for the proper solution.

What is easier - to fix all instances which statically declare, or
to fix all instances which statically declare _and_ all the bodged up
alternative solutions?
