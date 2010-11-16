Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0KPTNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:13:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:56000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab0KPTNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:13:22 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: david@lang.hm, Paul Menage <menage@google.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101116190916.GD13092@redhat.com>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <1289916683.2109.625.camel@laptop>
	 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	 <20101116170312.GA19327@tango.0pointer.de>
	 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	 <20101116181603.GC19327@tango.0pointer.de>
	 <1289931715.2109.648.camel@laptop>
	 <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
	 <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm>
	 <1289933965.2109.652.camel@laptop>  <20101116190916.GD13092@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 20:13:20 +0100
Message-ID: <1289934800.2109.653.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 14:09 -0500, Vivek Goyal wrote:

> I think this might create some issues with controllers which support some
> kind of upper limit on resource usage. These hidden group can practically
> consume any amount of resource and because use space tools can't see these,
> they will not be able to place a limit or control it.
> 
> If it is done from user space and cgroups are visible, then user can 
> atleast monitor the resource usage and do something about it.

Its cpu-controller only, and then only for SCHED_OTHER tasks which are
proportionally fair.


