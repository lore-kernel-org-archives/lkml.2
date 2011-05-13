Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab1EMIW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:22:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797Ab1EMIW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:22:57 -0400
Date: Fri, 13 May 2011 10:22:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Sched_autogroup and niced processes
Message-ID: <20110513082250.GB13647@elte.hu>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
 <1305273950.15080.7.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305273950.15080.7.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > > time make -j12 # with seti@home running
> > > real    4m16.753s
> > > user    10m33.770s
> > > sys     1m39.710s
> > >
> > > time make -j12 # without seti@home running
> > > real    2m12.480s
> > > user    10m11.580s
> > > sys     1m39.980s

I think the practical question here is to make seti@home run more idle.

Are there some magic cgroup commands you could recommend for that?

Thanks,

	Ingo
