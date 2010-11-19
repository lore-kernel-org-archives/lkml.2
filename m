Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0KSMAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:00:19 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39567 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0KSMAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:00:17 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andev <debiandev@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <AANLkTikLjQZiDcQx7HfgznPgFmYOfaN9of2ZtWLEvno8@mail.gmail.com>
References: <20101116170312.GA19327@tango.0pointer.de>
	 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	 <20101116181603.GC19327@tango.0pointer.de>
	 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	 <20101116202839.GC27235@tango.0pointer.de>
	 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
	 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
	 <20101116211909.GB16589@tango.0pointer.de>
	 <20101116233934.GC1568@thunk.org> <20101117002159.GA3184@tango.0pointer.de>
	 <20101117020626.GB3290@thunk.org>
	 <AANLkTikLjQZiDcQx7HfgznPgFmYOfaN9of2ZtWLEvno8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 12:59:53 +0100
Message-ID: <1290167993.2109.1562.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 00:20 -0500, Andev wrote:
> On Tue, Nov 16, 2010 at 9:06 PM, Ted Ts'o <tytso@mit.edu> wrote:
> 
> >
> > That works for me.  One suggestion is that in addition to "opt-out",
> > it should be also possible for an application launcher file to specify
> > a specific cgroup name that should be used.  That would allow multiple
> > applications in a group to assigned to the same cgroup.
> 
> +1 for implementing this in systemd than in the kernel.
> 
> The userspace has much more info about which process needs to go into
> which group.

-1 on your systemd/gnome/wm/etc. crap, that means it will become
impossible to sanely switch off (gnome firmly believes knobs are evil),
leaving everybody who _does_ know wth they're doing up a certain creek
without a paddle.
