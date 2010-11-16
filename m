Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab0KPAEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:04:47 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53625 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752244Ab0KPAEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:04:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+eSWwIK/iewVh6CS1Qua+EorPNAkNHqPQu61q0Af
	uUV7XiJEXxsPP1
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <AANLkTikztvdgFucCUjZ+A5Je-LUKLknV5+aznVvL98oQ@mail.gmail.com>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net> <30291.1289860866@localhost>
	 <1289864780.14719.172.camel@maggy.simson.net>
	 <AANLkTikztvdgFucCUjZ+A5Je-LUKLknV5+aznVvL98oQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 17:04:30 -0700
Message-ID: <1289865870.14719.185.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 15:50 -0800, Linus Torvalds wrote:
> On Mon, Nov 15, 2010 at 3:46 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Mon, 2010-11-15 at 17:41 -0500, Valdis.Kletnieks@vt.edu wrote:
> >
> >> > +extern void sched_autogroup_detatch(struct task_struct *p);
> >>
> >> sched_autogroup_detach() instead?
> >
> > Hm, why?
> 
> You really aren't a good speller of that word, are you?

<stare>  d e t a c h... d e t a t....t?  aw crap. Guess not.

Couldn't even see it.

	-Mike

