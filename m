Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab0KPS43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:56:29 -0500
Received: from mail.lang.hm ([64.81.33.126]:34834 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0KPS42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:56:28 -0500
Date: Tue, 16 Nov 2010 10:55:30 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Paul Menage <menage@google.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm>
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net> <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de>
 <1289931715.2109.648.camel@laptop> <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Paul Menage wrote:

> On Tue, Nov 16, 2010 at 10:21 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> Not quite the same, you're nesting one level deeper. But the reality is,
>> not a lot of people will change their userspace.
>
> That's a weak argument - not a lot of people will (explicitly) change
> their kernel either - they'll get a fresh kernel via their distro
> updates, as they would get userspace updates. So it's only a few
> people (distros) that actually need to make such a change.

what is the downside of this patch going to be?

people who currently expect all the processes to compete equally will now 
find that they no longer do so. If I am understanding this correctly, this 
could mean that a box that was dedicated to running one application will 
now have that application no longer dominate the system, instead it will 
'share equally' with the housekeeping apps on the system.

what would need to be done to revert to the prior situation?

David Lang
