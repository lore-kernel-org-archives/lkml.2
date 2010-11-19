Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0KSNVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:21:44 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37682 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0KSNVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:21:42 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: Andev <debiandev@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <8762vtsbx5.fsf@gmail.com>
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
	 <1290167993.2109.1562.camel@laptop>  <8762vtsbx5.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 14:21:18 +0100
Message-ID: <1290172878.2109.1590.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 08:03 -0500, Ben Gamari wrote:
> On Fri, 19 Nov 2010 12:59:53 +0100, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Fri, 2010-11-19 at 00:20 -0500, Andev wrote:
> > > +1 for implementing this in systemd than in the kernel.
> > > 
> > > The userspace has much more info about which process needs to go into
> > > which group.
> > 
> > -1 on your systemd/gnome/wm/etc. crap, that means it will become
> > impossible to sanely switch off (gnome firmly believes knobs are evil),
> > leaving everybody who _does_ know wth they're doing up a certain creek
> > without a paddle.
> 
> Please, can we stop with this false dichotomy? This is decidedly not
> true and as Lennart has already pointed out, the knob already exists in
> systemd.

It does for systemd, but he also said he's proposing patches for other
userspace components (something gnome). And as we all know, gnome is not
big on options, its their way or the high-way.

>  You may like the kernel approach, but this does not mean there
> is no place for grouping driven by userspace.

My concern is that I don't want to go trawling through a dozen unrelated
userspace package configurations to disable all this.


