Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1HDTgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 15:36:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab1HDTgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 15:36:47 -0400
Date: Thu, 4 Aug 2011 21:35:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: Tree for July 25 (xen)
Message-ID: <20110804193534.GB12729@elte.hu>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
 <20110725144629.b752bf14.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110725144629.b752bf14.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Mon, 25 Jul 2011 16:25:42 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> xen has lots of build errors and warnings (all on x86_64).
> 
>   CC      arch/x86/xen/setup.o
> In file included from arch/x86/include/asm/xen/hypercall.h:42,
>                  from arch/x86/xen/setup.c:19:
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list
> include/trace/events/xen.h:31: warning: its scope is only this definition or declaration, which is probably not what you want
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list
> In file included from arch/x86/xen/setup.c:19:
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_fpu_taskswitch':
> arch/x86/include/asm/xen/hypercall.h:465: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_update_va_mapping':
> arch/x86/include/asm/xen/hypercall.h:483: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_grant_table_op':
> arch/x86/include/asm/xen/hypercall.h:495: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_update_va_mapping_otherdomain':
> arch/x86/include/asm/xen/hypercall.h:516: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_update_descriptor':
> arch/x86/include/asm/xen/hypercall.h:534: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_memory_op':
> arch/x86/include/asm/xen/hypercall.h:544: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_mmu_update':
> arch/x86/include/asm/xen/hypercall.h:557: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_mmuext_op':
> arch/x86/include/asm/xen/hypercall.h:570: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_set_gdt':
> arch/x86/include/asm/xen/hypercall.h:580: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
> arch/x86/include/asm/xen/hypercall.h: In function 'MULTI_stack_switch':
> arch/x86/include/asm/xen/hypercall.h:591: warning: passing argument 1 of 'trace_xen_mc_entry' from incompatible pointer type
> include/trace/events/xen.h:48: note: expected 'struct multicall_entry *' but argument is of type 'struct multicall_entry *'
>   CC      arch/x86/xen/multicalls.o
> In file included from arch/x86/include/asm/xen/hypercall.h:42,
>                  from arch/x86/xen/multicalls.c:26:
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list
> include/trace/events/xen.h:31: warning: its scope is only this definition or declaration, which is probably not what you want
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list
> include/trace/events/xen.h:31: warning: 'struct multicall_entry' declared inside parameter list

These build failures are still triggering upstream:

 arch/x86/xen/trace.c:44:2: error: array index in initializer not of integer type
 arch/x86/xen/trace.c:44:2: error: (near initialization for ‘xen_hypercall_names’)
 arch/x86/xen/trace.c:45:1: error: ‘__HYPERVISOR_arch_4’ undeclared here (not in a function)
 arch/x86/xen/trace.c:45:2: error: array index in initializer not of integer type
 arch/x86/xen/trace.c:45:2: error: (near initialization for ‘xen_hypercall_names’)

even after:

 b3c4b9825075: xen/tracing: fix compile errors when tracing is disabled.

Btw., that the heck is going on with the commit that introduced the 
build failure:

 commit bd9ddc875b6659f9f74dcfd285c472bc58041abd
 Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 AuthorDate: Mon Jun 20 17:52:13 2011 -0700
 Commit:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 CommitDate: Mon Jul 18 15:43:46 2011 -0700

It was apparently rebased shortly before the merge window and sent to 
Linus 3 days later, with little to no linux-next testing ...

I'm absolutely unhappy about how the Xen tree is being run. It's 
using a sloppy, crappy workflow and it is producing crap.

Thanks,

	Ingo
