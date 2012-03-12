Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2CLF6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 01:58:02 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43769 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab2CLF5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 01:57:54 -0400
Date: Mon, 12 Mar 2012 11:24:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20120312055437.GH13284@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120310174501.19949.50137.sendpatchset@srdronam.in.ibm.com>
 <20120311140735.GA27053@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120311140735.GA27053@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031205-9360-0000-0000-000004719BB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-03-11 15:07:36]:

> 
> Which tree are these patches against? They don't apply to 
> tip:master cleanly.

To me it applied cleanly on top of 
commit 90549600c550ab189c4611060603f7f15bda2b5e
Merge: f14da8d 708adc5
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Mar 8 12:26:01 2012 +0100

	Merge branch 'tools/kvm'



> 
> Also, for patch titles please use the same capitalization style 
> as you see in the commits I've already applied.
> 

Okay.
Will resend the patchset on top of tip/master 81549e96cec66b0eb5efac58df9e503290dad5c1 

-- 
Thanks and Regards
Srikar

