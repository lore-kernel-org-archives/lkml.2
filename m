Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab0KPTnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:43:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:59103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab0KPTnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:43:49 -0500
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
In-Reply-To: <20101116194036.GH13092@redhat.com>
References: <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	 <20101116181603.GC19327@tango.0pointer.de>
	 <1289931715.2109.648.camel@laptop>
	 <AANLkTik7cR_5JJWfk8SEf3Dngfe7yZvuivJ66dVDOuAk@mail.gmail.com>
	 <alpine.DEB.2.00.1011161047060.3718@asgard.lang.hm>
	 <1289933965.2109.652.camel@laptop> <20101116190916.GD13092@redhat.com>
	 <1289934800.2109.653.camel@laptop> <20101116192206.GG13092@redhat.com>
	 <1289935527.2109.655.camel@laptop>  <20101116194036.GH13092@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 20:43:25 +0100
Message-ID: <1289936605.2109.657.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 14:40 -0500, Vivek Goyal wrote:
> 
> So point being that these autogroups being hidden is a concern. Can we
> do something so that these groups show up in cgroup hierarchy and are
> then user controllable. 

Well, either you disable the autogroup feature, or explicitly put each
task in a taskgroup other than root and you'll be fine.

Nothing avoids that from working.
