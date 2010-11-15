Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0KOACf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:02:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39301 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754853Ab0KOACe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:02:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BoBJeVwuBvNAi62ugC/TvQ5+7jiSigWfrxEFPAm
	+t7OKOuuEd0lZO
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
References: <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net>
	 <20101111202703.GA16282@redhat.com>
	 <1289514000.21413.204.camel@maggy.simson.net>
	 <20101112181240.GB8659@redhat.com>
	 <1289648524.22764.149.camel@maggy.simson.net>
	 <1289755150.3228.44.camel@maggy.simson.net>
	 <20101114174921.GA1569@arch.trippelsdorf.de>
	 <1289758238.17491.12.camel@maggy.simson.net>
	 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
	 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 17:02:17 -0700
Message-ID: <1289779337.28119.8.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 12:20 -0800, Linus Torvalds wrote:
> On Sun, Nov 14, 2010 at 11:28 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > This catless version looks very good to me
> 
> Oh, btw, maybe one comment: is CONFIG_SCHED_AUTOGROUP_DEBUG even worth
> having as a config option? The only thing it enables is the small
> /proc interface, and I don't see any downside to just always having
> that if you have AUTOGROUP enabled in the first place.

If the on/off is available, you can silently strand pinned tasks forever
in an autogroup.  So, I tied the on/off switch to the global move so the
user won't be surprised.

	-Mike

