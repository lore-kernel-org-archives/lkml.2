Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936687Ab2C3XFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:05:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:41983 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934194Ab2C3XE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:04:57 -0400
Date: Sat, 31 Mar 2012 01:04:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
In-Reply-To: <20120330221836.GN17822@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1203310044580.2542@ionos>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F7616F5.4070000@zytor.com> <alpine.LFD.2.02.1203302333560.2542@ionos> <20120330221836.GN17822@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2012, Andi Kleen wrote:

> > So if a guest exits due to an external event it's easy to inspect the
> > state of that guest and avoid to schedule away when it was interrupted
> > in a spinlock held section. That guest/host shared state needs to be
> 
> On a large system under high contention sleeping can perform surprisingly
> well. pthread mutexes have a tendency to beat kernel spinlocks there.
> So avoiding sleeping locks completely (that is what pv locks are
> essentially) is not necessarily that good.

Care to back that up with numbers and proper trace evidence instead of
handwaving?

I've stared at RT traces and throughput problems on _LARGE_ machines
long enough to know what I'm talking about and I can provide evidence
in a split second.

> Your proposal is probably only a good idea on low contention
> and relatively small systems.

Sigh, you have really no fcking clue what you are talking about.

On RT we observed scalabilty problems way before hardware was
available to expose them. So what's your point?

Put up or shut up, really!

    tglx
