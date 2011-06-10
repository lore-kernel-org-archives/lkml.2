Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1FJPWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:22:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757703Ab1FJPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:22:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110610100339.GE22466@vostochny.stro.at>
References: <20110609214241.GA4849@sepie.suse.cz> <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
 <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com> <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
 <BANLkTinKMmYG7=KBHr2LfOYzcgbtszwy5g@mail.gmail.com> <BANLkTinQ2mL1eNPzMHjDjXnLyv58annZmA@mail.gmail.com>
 <BANLkTi=wQaUSagZjptGnvUHNpJeMm0C6yw@mail.gmail.com> <BANLkTinZGuOE3G5Ro0=LB9Y8wcHVgk-3ug@mail.gmail.com>
 <20110610100339.GE22466@vostochny.stro.at>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Jun 2011 08:22:27 -0700
Message-ID: <BANLkTin+RBL9aYzWeTBZ2Fj_m+8WuA_Ckg@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
To: maximilian attems <max@stro.at>
Cc: Ray Lee <ray-lk@madrabbit.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 3:03 AM, maximilian attems <max@stro.at> wrote:
>
> you have forgotten the rule that linus himself is allowed to break userland. :P

No.

But Linus _is_ allowed to try to fix problems. So what I'm trying to do is:

 - see if we can find work-arounds for known broken packages (by
giving them a three-digit version number despite the kernel actually
only having two digits)

 - if no such work-arounds can be done without excessive hackery, at
least make sure that the packages in question know that they are
broken, so that they get fixed and we can drop the third digit later
even if we don't drop it at 3.0 itself.

It does look like there are too many problems to actually make it call
itself "3.0", and that's sad. That's not an excuse for not trying to
get those problems fixed, though.

                       Linus
