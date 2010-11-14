Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0KNXn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 18:43:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36228 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755361Ab0KNXn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 18:43:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18kfQgmYIwkCXEg8UAUykjMsxAdG74CXKbmHyrNsc
	gpLcp61Ixp8Pdl
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimHtjH3YvtX6i542_XjfFeuvG-AnU8i224a1R4j@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 16:43:09 -0700
Message-ID: <1289778189.5154.10.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 12:48 -0800, Linus Torvalds wrote:
> On Sun, Nov 14, 2010 at 12:27 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2010.11.14 at 12:20 -0800, Linus Torvalds wrote:
> >>
> >> It isn't like it's some traditional kernel debug feature that makes
> >> things slower or adds tons of debug output.
> >
> > It also enables the sched_autogroup_handler, that you disliked seeing in
> > the previous version.
> 
> Yes, but that one exists only to make things "exact". I don't really
> see why it exists. What's the point of doing the task movement, if the
> group information is just going to be ignored anyway?

Not only. pinned tasks would stay in their autogroup until somebody
moved them to a cgroup.  Them wandering back over time would be fine,
and all but pinned tasks will.

	-Mike


