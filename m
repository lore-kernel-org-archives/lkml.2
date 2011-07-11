Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab1GKOLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:11:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37843 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab1GKOLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:11:46 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jul 2011 10:11:45 EDT
Date: Mon, 11 Jul 2011 16:03:03 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        omegamoon@gmail.com, eric.y.miao@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: zaurus patches -- arm/pxa -- is Eric alive
Message-ID: <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
References: <20110711134150.GA15506@localhost.ucw.cz> <CALT56yM+fNs_2QorWK0=gr2um1H3vDX+HXPCi9bmKDdOdSvptA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALT56yM+fNs_2QorWK0=gr2um1H3vDX+HXPCi9bmKDdOdSvptA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > There are some rather critical patches for zaurus C-3000 (spitz)
> > available... with no response. What is going on?
> 
> Eric seems alive. At least he've sent pull requests few days ago.
> Maybe you can point to those patches, that you mention as critical?

Perhaps the most critical one is:

[PATCH] MAX1111: Fix race condition causing NULL pointer exception

http://ns1.yosemitephotos.net/lists/arm-kernel/msg125356.html

Which fixes memory corruption that caused random oops.

And then there is a bunch of fixes for charging and power management from
Pavel Machek:

Disable CF during suspend

https://lkml.org/lkml/2011/5/21/46

and spitz pm

https://lkml.org/lkml/2011/5/21/72
https://lkml.org/lkml/2011/5/21/73
https://lkml.org/lkml/2011/5/21/76

-- 
metan
