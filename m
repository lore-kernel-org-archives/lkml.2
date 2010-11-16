Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0KPUWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:22:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51305 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab0KPUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:22:12 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Z5CK3fOgXNs9odKnQNFHsbavpOvw8c3kh6zEG@mail.gmail.com>
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <AANLkTi=Z5CK3fOgXNs9odKnQNFHsbavpOvw8c3kh6zEG@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Nov 2010 21:21:56 +0100
Message-ID: <AANLkTikJoeOOAJco_y8pF0Qa9K239oEWh_p8q1605chx@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 20:03, Pekka Enberg <penberg@kernel.org> wrote:
> On Tue, Nov 16, 2010 at 8:49 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> User-level configuration for something that should just work is
>> annoying. We can do better.
>
> Completely agreed. Desktop users should not be required to fiddle with
> kernel knobs from userspace to fix interactivity problems. Having sane
> defaults applies to the kernel as much as it does to userspace.

The only problem is that *desktop* users use *desktop* apps, which
never have a controlling tty.

This is a *nerd* config not helping any regular desktop user. You guys
are optimizing the system for people who build kernels and watch
movies at the same time, not for desktop users. Hooking into TTYs
works for almost nobody sane out there. :)

It's all fine, no comment on the patch, it's a nice hack. But please
stop talking about the *desktop* here, it has almost nothing to do
with it.

Kay
