Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1H1Jff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 05:35:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56814 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1H1Jfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 05:35:30 -0400
Date: Sun, 28 Aug 2011 11:35:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cyril Hrubis <metan@ucw.cz>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, thommycheck@gmail.com,
        Marek Vasut <marek.vasut@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>, arminlitzel@web.de,
        kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
        lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
        eric.y.miao@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>,
        zaurus-devel@www.linuxtogo.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: zaurus patches -- arm/pxa -- is Eric alive
Message-ID: <20110828093526.GA17995@elf.ucw.cz>
References: <20110711134150.GA15506@localhost.ucw.cz>
 <CALT56yM+fNs_2QorWK0=gr2um1H3vDX+HXPCi9bmKDdOdSvptA@mail.gmail.com>
 <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711140303.GA32532@atrey.karlin.mff.cuni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > There are some rather critical patches for zaurus C-3000 (spitz)
> > > available... with no response. What is going on?
> > 
> > Eric seems alive. At least he've sent pull requests few days ago.
> > Maybe you can point to those patches, that you mention as critical?
> 
> Perhaps the most critical one is:
> 
> [PATCH] MAX1111: Fix race condition causing NULL pointer exception
> 
> http://ns1.yosemitephotos.net/lists/arm-kernel/msg125356.html

> Which fixes memory corruption that caused random oops.

This one is in 3.1-rc3. Good.

> And then there is a bunch of fixes for charging and power management from
> Pavel Machek:
> 
> Disable CF during suspend
> 
> https://lkml.org/lkml/2011/5/21/46

This one is not. Could we get it pushed?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
