Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0KSNDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:03:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39763 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0KSNDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:03:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=Y1mMpnu9ZI34sxm1/q3e+T7Y0yee6lq3QYNDHmISrew9BzvpWhRygM/j5EK2l/gWqb
         GFFv1mWs/B6OzIyvt+6LWWbOc7hpJhAfZDsrbC/6AEI6/F190H6N6RPLbgnvMWqFvlyw
         E36hvElozKnjBu3ti6XYG+lbTgnvxJ7EKY5GA=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andev <debiandev@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <1290167993.2109.1562.camel@laptop>
References: <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com> <20101116202839.GC27235@tango.0pointer.de> <20101116205243.64e4a67a@lxorguk.ukuu.org.uk> <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com> <20101116211909.GB16589@tango.0pointer.de> <20101116233934.GC1568@thunk.org> <20101117002159.GA3184@tango.0pointer.de> <20101117020626.GB3290@thunk.org> <AANLkTikLjQZiDcQx7HfgznPgFmYOfaN9of2ZtWLEvno8@mail.gmail.com> <1290167993.2109.1562.camel@laptop>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Nov 2010 08:03:34 -0500
Message-ID: <8762vtsbx5.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 12:59:53 +0100, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2010-11-19 at 00:20 -0500, Andev wrote:
> > +1 for implementing this in systemd than in the kernel.
> > 
> > The userspace has much more info about which process needs to go into
> > which group.
> 
> -1 on your systemd/gnome/wm/etc. crap, that means it will become
> impossible to sanely switch off (gnome firmly believes knobs are evil),
> leaving everybody who _does_ know wth they're doing up a certain creek
> without a paddle.

Please, can we stop with this false dichotomy? This is decidedly not
true and as Lennart has already pointed out, the knob already exists in
systemd. You may like the kernel approach, but this does not mean there
is no place for grouping driven by userspace.

- Ben
