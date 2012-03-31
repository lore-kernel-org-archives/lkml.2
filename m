Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2CaIMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 04:12:07 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47204 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2CaIL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 04:11:58 -0400
Date: Sat, 31 Mar 2012 10:11:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
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
Message-ID: <20120331081152.GB15958@gmail.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
 <4F7616F5.4070000@zytor.com>
 <alpine.LFD.2.02.1203302333560.2542@ionos>
 <20120330221836.GN17822@one.firstfloor.org>
 <alpine.LFD.2.02.1203310044580.2542@ionos>
 <20120331000843.GO17822@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120331000843.GO17822@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > Care to back that up with numbers and proper trace evidence 
> > instead of handwaving?
> 
> E.g. my plumbers presentations on lock and mm scalability from 
> last year has some graphs that show this very clearly, plus 
> some additional data on the mutexes. This compares to the 
> glibc futex locks, which perform much better than the kernel 
> mutex locks on larger systems under higher contention

If you mean these draft slides:

  http://www.halobates.de/plumbers-fork-locks_v2.pdf

it has very little verifiable information in it. It just 
cryptically says lock hold time "microbenchmark", which might or 
might not be a valid measurement.

You could have been honest and straightforward in your first 
mail:

 "I ran workload X on machine Y, and got results Z."

Instead you are *hindering* the discussion:

> Given your tone I will not supply an URL. [...]

If you meant the above URL then it's not the proper numbers 
Thomas asked for, just some vague slides. If you meant something 
else then put up or shut up.

Thanks,

	Ingo
