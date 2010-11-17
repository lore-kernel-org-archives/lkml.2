Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab0KQAWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:22:21 -0500
Received: from tango.0pointer.de ([85.214.72.216]:59679 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564Ab0KQAWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:22:20 -0500
Date: Wed, 17 Nov 2010 01:21:59 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117002159.GA3184@tango.0pointer.de>
References: <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
 <20101116211909.GB16589@tango.0pointer.de>
 <20101116233934.GC1568@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116233934.GC1568@thunk.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 18:39, Ted Ts'o (tytso@mit.edu) wrote:

> 
> On Tue, Nov 16, 2010 at 10:19:09PM +0100, Lennart Poettering wrote:
> > Well, my plan was actually to by default put everything into its own
> > group, and then let users opt-out of that for specific processes, if the
> > want to.
> 
> How many users are likely to do this, though?
> 
> I think you really want to make this be something which the
> application can specify by default that they should start in their own
> cgroup.  One idea might be to it to the applications menu entry:
> 
> http://standards.freedesktop.org/desktop-entry-spec/latest/
> 
> ... so there would be a new key value pair, "start_in_cgroup", that
> would allow the user to start an application in their own cgroup.  It
> would be up to the desktop launcher to honor that if it was present.

This is pretty much in line with what I want to do, except I want
opt-out, not opt-in behaviour here.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
