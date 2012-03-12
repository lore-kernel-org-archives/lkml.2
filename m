Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2CLGLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:11:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab2CLGLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:11:13 -0400
Date: Mon, 12 Mar 2012 07:10:37 +0100
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
Message-ID: <20120312061037.GA32408@elte.hu>
References: <20120310174501.19949.50137.sendpatchset@srdronam.in.ibm.com>
 <20120311140735.GA27053@elte.hu>
 <20120312055437.GH13284@linux.vnet.ibm.com>
 <20120312060503.GA1479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312060503.GA1479@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > To me it applied cleanly on top of 
> > commit 90549600c550ab189c4611060603f7f15bda2b5e
> 
> It's a new commit:
> 
>  c94082656dac: x86: Use enum instead of literals for trap values
> 
> Interacting with this cleanup:
> 
>  x86/trivial: Rename trap_no to trap_nr in thread struct

Btw., you can resend just this merged patch instead of resending 
the whole series, as the other bits should still apply cleanly.

Thanks,

	Ingo
