Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1CHI1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 03:27:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42208 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755599Ab1CHI1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 03:27:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+AF8tr+NeA84NuiJyGupZItkdrSCnCH27clZx4vh
	BZI3aiVfOVdUFR
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTinToHNbC_Yu91GfzcSTDrzSFFb87qQDGJ1vj4sV@mail.gmail.com>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	 <1299490414.14465.74.camel@marge.simson.net>
	 <1299508052.8093.1.camel@marge.simson.net>
	 <AANLkTinToHNbC_Yu91GfzcSTDrzSFFb87qQDGJ1vj4sV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 09:26:56 +0100
Message-ID: <1299572816.7949.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 16:23 +0800, Yong Zhang wrote:
> On Mon, Mar 7, 2011 at 10:27 PM, Mike Galbraith <efault@gmx.de> wrote:

> > ---
> > Index: linux-2.6/include/linux/sched.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/sched.h
> > +++ linux-2.6/include/linux/sched.h
> > @@ -1941,6 +1941,7 @@ static inline unsigned int get_sysctl_ti
> >  #endif
> >  extern unsigned int sysctl_sched_rt_period;
> >  extern int sysctl_sched_rt_runtime;
> > +extern int sysctl_sched_rt_borrow_runtime;
> 
> It should be under CONFIG_SMP.

I think I should do it differently anyway.

	-Mike

