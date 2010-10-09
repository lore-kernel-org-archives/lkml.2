Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948Ab0JIAZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:25:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49308 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab0JIAZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:25:58 -0400
Date: Sat, 9 Oct 2010 01:25:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009002546.GB14675@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <20101007192245.GC26435@n2100.arm.linux.org.uk> <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com> <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <20101009000046.GA30616@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101009000046.GA30616@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 05:00:46PM -0700, Greg KH wrote:
> But you can't expect that you make this change, and not fix up the
> drivers, and people would be happy, right?  The rule for API changes
> like this, or anything, is that the person making the change fixes the
> other drivers, and that seems to be the issue here.

Let's entirely revert the change and wait for people's data to be
corrupted then.  I don't have the time nor the motivation to work
through crap driver code to fix up these unreliable games which are
already illegal on platforms such as x86.

If people want their system to be unpredictable, then let's carry on
giving them the rope to hang themselves in that manner.

> Any pointers to patches where people have fixed up the drivers?

Despite the discussion, I'm unaware of anyone really taking the issue
seriously and producing any patches during the last six months.

So, I say sod it, let's revert the change.
