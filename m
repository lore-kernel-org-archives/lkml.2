Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab0KPVTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:19:30 -0500
Received: from tango.0pointer.de ([85.214.72.216]:47412 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab0KPVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:19:29 -0500
Date: Tue, 16 Nov 2010 22:19:09 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116211909.GB16589@tango.0pointer.de>
References: <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 13:08, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> 
> On Tue, Nov 16, 2010 at 12:52 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Well, if I make behaviour like this default in systemd, then this means
> >> there won't be user setup for this. Because the distros shipping systemd
> >> will get this as default behaviour.
> >
> > And within the desktop where would you put this - in the window manager
> > on the basis of top level windows or in the app startup ?
> 
> Btw, I suspect either of these are reasonable. In fact, I don't think
> it would be at all wrong to have the desktop launcher have an option
> to "launch in a group" (although I think it would need to be named
> better than that). Right now, when you create desktop launchers under
> at least gnome, it allows you to specify a "type" for the application
> ("Application" or "Application in Terminal"), and maybe there could be
> a "CPU-bound application" choice that would set it in a CPU group of
> its own. Or whatever.

Well, my plan was actually to by default put everything into its own
group, and then let users opt-out of that for specific processes, if the
want to.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
