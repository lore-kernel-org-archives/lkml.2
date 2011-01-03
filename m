Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1ACOVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:21:07 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49170 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754847Ab1ACOVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:21:06 -0500
Date: Mon, 3 Jan 2011 15:17:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, gregkh@suse.de
Subject: Re: zaurus bluetooth regression
Message-ID: <20110103141727.GA1536@ucw.cz>
References: <20110102204532.GA12860@elf.ucw.cz>
 <20110102203023.GA1545@ucw.cz>
 <AANLkTika7HAEc+BbqSnbo8viUt4nOqoeB69qWZs85-9s@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTika7HAEc+BbqSnbo8viUt4nOqoeB69qWZs85-9s@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> It seems this commit
> >>
> >> commit 7a56aa45982bb87bfca98a2832b5ae782c03364a
> > ...
> >> ...is responsible for my bluetooth problems on zaurus -- at least
> >> bisect pointed to it,  as I use 16C950-based bluetooth card, it seems
> >> very logical. I'll try 2.6.37-rc8 with that patch reverted...
> >>
> >
> > And yes, 37-rc8 with that reverted results in working bluetooth, so
> > yrs, that patch is responsible.
> 
> could you tell, what kind of problem you're encountering and if you
> could tell, which flag UART_CAP_EFR or UART_CAP_SLEEP causes the
> problem?

Bluetooth will not work with 'tx command timeout', details should be
in bugzilla.

CAP_EFR seems to cause the problem.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
