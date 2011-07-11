Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1GKOWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:22:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47620 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1GKOWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:22:12 -0400
Date: Mon, 11 Jul 2011 16:22:10 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, thommycheck@gmail.com,
        Marek Vasut <marek.vasut@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>, arminlitzel@web.de,
        kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
        lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
        Pavel Machek <pavel@ucw.cz>, eric.y.miao@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        zaurus-devel@www.linuxtogo.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: zaurus patches -- arm/pxa -- is Eric alive
Message-ID: <20110711142210.GB32532@atrey.karlin.mff.cuni.cz>
References: <20110711134150.GA15506@localhost.ucw.cz> <CALT56yM+fNs_2QorWK0=gr2um1H3vDX+HXPCi9bmKDdOdSvptA@mail.gmail.com> <20110711140303.GA32532@atrey.karlin.mff.cuni.cz> <20110711141712.GD11153@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711141712.GD11153@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > > There are some rather critical patches for zaurus C-3000 (spitz)
> > > > available... with no response. What is going on?
> > > 
> > > Eric seems alive. At least he've sent pull requests few days ago.
> > > Maybe you can point to those patches, that you mention as critical?
> > 
> > Perhaps the most critical one is:
> > 
> > [PATCH] MAX1111: Fix race condition causing NULL pointer exception
> > 
> > http://ns1.yosemitephotos.net/lists/arm-kernel/msg125356.html
> 
> Ahem, this one was opposed to. The right one seems to be:
> 
> http://ns1.yosemitephotos.net/lists/arm-kernel/msg125592.html
> 
> Note that it is a hwmon-driver and neither the apropriate list nor
> maintainers have been CCed. Eric cannot take this patch. Check
> MAINTAINERAS (or use scripts/get_maintainer.pl) to find the right people
> and this will increase chances to get your patch upstream a lot.

Right, CCing patch author.

-- 
metan
