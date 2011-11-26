Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1KZCYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 21:24:17 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57903 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1KZCYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 21:24:15 -0500
Date: Sat, 26 Nov 2011 07:52:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH v7 3.2-rc2 12/30] uprobes: Handle breakpoint and
 Singlestep
Message-ID: <20111126022257.GA3291@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111118110903.10512.88532.sendpatchset@srdronam.in.ibm.com>
 <1322234662.2535.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322234662.2535.8.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112602-9360-0000-0000-000000F7CDD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-11-25 16:24:22]:

> On Fri, 2011-11-18 at 16:39 +0530, Srikar Dronamraju wrote:
> 
> > +       consumer = uprobe->consumers;
> > +       for (consumer = uprobe->consumers; consumer;
> > +                                       consumer = consumer->next) { 
> 
> that first expression seems redundant..

Yes,  will remove.

