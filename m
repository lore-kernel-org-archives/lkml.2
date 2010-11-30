Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0K3XuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:50:04 -0500
Received: from kroah.org ([198.145.64.141]:42976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0K3XuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:50:03 -0500
Date: Tue, 30 Nov 2010 15:49:37 -0800
From: Greg KH <greg@kroah.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Message-ID: <20101130234937.GA7156@kroah.com>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local>
 <201011261224.59490.arnd@arndb.de>
 <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com>
 <201011301621.48140.arnd@arndb.de>
 <20101130184049.GC8521@n2100.arm.linux.org.uk>
 <20101130184834.GA16055@kroah.com>
 <20101130220550.GD8521@n2100.arm.linux.org.uk>
 <20101130230533.GA11342@kroah.com>
 <20101130234215.GE8521@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130234215.GE8521@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:42:15PM +0000, Russell King - ARM Linux wrote:
> > It's a work in progress, but wherever possible, I encourage people to
> > not make 'struct device' static.
> 
> Right, so saying to ARM developers that they can't submit code which
> adds new static device structures is rather problematical then, and
> effectively brings a section of kernel development to a complete
> standstill - it means no support for additional ARM platforms until
> this issue is resolved.  (This "condition" was mentioned by Arnd
> earlier in this thread, and was put in such a way that it was now
> a hard and fast rule.)

Sorry, I didn't mean for that to be mentioned that way at all, as I know
the issues that are keeping this from happening.

> I feel it would be better to allow the current situation to continue.
> If we start telling people that they can't use statically declared
> devices without first having an alternative, we'll end up with people
> inventing their own individual - and different - solutions to this
> problem, which could actually make the problem harder to resolve in
> the longer term.

Ok, but again, I do encourage, wherever possible, that people do not
statically create a 'struct device'.

thanks,

greg k-h

