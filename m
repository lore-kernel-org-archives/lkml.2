Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0KPUbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:31:25 -0500
Received: from tango.0pointer.de ([85.214.72.216]:41380 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab0KPUbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:31:23 -0500
Date: Tue, 16 Nov 2010 21:31:03 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116203103.GD27235@tango.0pointer.de>
References: <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <AANLkTi=Z5CK3fOgXNs9odKnQNFHsbavpOvw8c3kh6zEG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Z5CK3fOgXNs9odKnQNFHsbavpOvw8c3kh6zEG@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 21:03, Pekka Enberg (penberg@kernel.org) wrote:

> 
> On Tue, Nov 16, 2010 at 8:49 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > User-level configuration for something that should just work is
> > annoying. We can do better.
> 
> Completely agreed. Desktop users should not be required to fiddle with
> kernel knobs from userspace to fix interactivity problems. Having sane
> defaults applies to the kernel as much as it does to userspace.

Jeez. Don't mentione the desktop. On the desktop this is compleltely
irrelevant. There are not TTYs on the desktop. There's no "make -j" of
the kernel tree on the desktop.

The kernel patch discussed here *has* *no* *relevance* for normal users.

The kernel patch discussed here is only relevant for people which start
mplayer from one terminal, and "make -j" from another.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
