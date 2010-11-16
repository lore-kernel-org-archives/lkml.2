Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab0KPT4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:56:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756670Ab0KPT4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:56:01 -0500
MIME-Version: 1.0
In-Reply-To: <20101116194036.GH13092@redhat.com>
References: <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <1289931715.2109.648.camel@laptop>
 <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
 <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm> <1289933965.2109.652.camel@laptop>
 <20101116190916.GD13092@redhat.com> <1289934800.2109.653.camel@laptop>
 <20101116192206.GG13092@redhat.com> <1289935527.2109.655.camel@laptop> <20101116194036.GH13092@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 11:49:25 -0800
Message-ID: <AANLkTimRo9qbbYNGP1G28cBip5VokNOyjMNe_u=fagnH@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, david@lang.hm,
        Paul Menage <menage@google.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:40 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> So point being that these autogroups being hidden is a concern. Can we
> do something so that these groups show up in cgroup hierarchy and are
> then user controllable.

I think that's valid, and I don't think it would be wrong to have some
interface to show them.

Of course, then it's an interface question, and you'd want to be a bit
careful in designing it.

                       Linus
