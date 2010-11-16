Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0KPSeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:34:19 -0500
Received: from smtp-out.google.com ([74.125.121.35]:32120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0KPSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AoqvHlU12AsIjOYO7MqM5ZjrYjTScXfTtx2vUlwZ9OR3hsES3DYjq6Huur7+JQIlkc
         prZxOhmpcxeh/iURgS4A==
MIME-Version: 1.0
In-Reply-To: <1289931715.2109.648.camel@laptop>
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <1289931715.2109.648.camel@laptop>
From: Paul Menage <menage@google.com>
Date: Tue, 16 Nov 2010 10:33:53 -0800
Message-ID: <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:21 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Not quite the same, you're nesting one level deeper. But the reality is,
> not a lot of people will change their userspace.

That's a weak argument - not a lot of people will (explicitly) change
their kernel either - they'll get a fresh kernel via their distro
updates, as they would get userspace updates. So it's only a few
people (distros) that actually need to make such a change.

Paul
