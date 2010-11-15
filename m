Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0KOOBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:01:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60427 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755672Ab0KOOBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:01:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+1Y5kXJ8W1R3nMJ1BYaHQNA5MaZRkqZlfDEJF4ps
	EX87UIeVCrvUVj
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikp=RJSpL1NYje89URu0St0RprUwR7ad8Q7a=-=@mail.gmail.com>
References: <1289489200.11397.21.camel@maggy.simson.net>
	 <20101111202703.GA16282@redhat.com>
	 <1289514000.21413.204.camel@maggy.simson.net>
	 <20101112181240.GB8659@redhat.com>
	 <1289648524.22764.149.camel@maggy.simson.net>
	 <1289755150.3228.44.camel@maggy.simson.net>
	 <20101114174921.GA1569@arch.trippelsdorf.de>
	 <1289758238.17491.12.camel@maggy.simson.net>
	 <AANLkTimy5DdF8qwGuk09iT3wHfXMjkiwRKxo-LuvEJzW@mail.gmail.com>
	 <AANLkTikjSCbcRnKOU=nd4os1sdW-GJkD6QVj=U5zPyu8@mail.gmail.com>
	 <20101114202734.GA1627@arch.trippelsdorf.de>
	 <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
	 <1289778189.5154.10.camel@maggy.simson.net>
	 <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <AANLkTikp=RJSpL1NYje89URu0St0RprUwR7ad8Q7a=-=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 07:00:58 -0700
Message-ID: <1289829658.16406.78.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 19:12 -0800, Linus Torvalds wrote:

> I'm also very happy with just what it does to interactive performance.
> Admittedly, my "testcase" is really trivial (reading email in a
> web-browser, scrolling around a bit, while doing a "make -j64" on the
> kernel at the same time), but it's a test-case that is very relevant
> for me. And it is a _huge_ improvement.

Next logical auto-step would be to try to subvert cfq.  At a glance,
io_context looks highly hackable for !CONFIG_CFQ_GROUP_IOSCHED case.
The other case may get interesting for someone not very familiar with
cfq innards, but I see a tempting looking subversion point.

	-Mike

