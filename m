Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2CLGFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:05:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2CLGFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:05:47 -0400
Date: Mon, 12 Mar 2012 07:05:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] uprobes/core: make macro names consistent.
Message-ID: <20120312060503.GA1479@elte.hu>
References: <20120310174501.19949.50137.sendpatchset@srdronam.in.ibm.com>
 <20120311140735.GA27053@elte.hu>
 <20120312055437.GH13284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312055437.GH13284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2012-03-11 15:07:36]:
> 
> > 
> > Which tree are these patches against? They don't apply to 
> > tip:master cleanly.
> 
> To me it applied cleanly on top of 
> commit 90549600c550ab189c4611060603f7f15bda2b5e

It's a new commit:

 c94082656dac: x86: Use enum instead of literals for trap values

Interacting with this cleanup:

 x86/trivial: Rename trap_no to trap_nr in thread struct

Also, while touching the trap_nr sites please use X86_TRAP_PF 
instead of '14' and X86_TRAP_MF instead of '16', etc.

Thanks,

	Ingo
