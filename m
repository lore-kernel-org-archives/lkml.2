Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2DTKHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:07:05 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56569 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab2DTKHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:07:02 -0400
Date: Fri, 20 Apr 2012 15:27:30 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH UPDATED 3/3] tracing: Provide trace events interface
 for uprobes
Message-ID: <20120420095730.GB8357@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
 <20120409091154.8343.50489.sendpatchset@srdronam.in.ibm.com>
 <20120411103043.GB29437@linux.vnet.ibm.com>
 <1334236456.23924.333.camel@gandalf.stny.rr.com>
 <20120414111206.GA24688@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120414111206.GA24688@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042010-5112-0000-0000-0000073DFE52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo, 


* Ingo Molnar <mingo@kernel.org> [2012-04-14 13:12:06]:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I'm fine with what I see here (still need to fix what Masami 
> > suggested).
> > 
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Ok - Srikar, mind sending the latest (3-patch?) series again, 
> with all suggestions and acks incorporated?
> 

I had re-posted the tracing bits http://lkml.org/lkml/2012/4/16/109
Masami has added his ack to the last patch. So all the three patches are
acked by Masami and Steven Rostedt. 

Also the perf bits  were posted here http://lkml.org/lkml/2012/4/16/175. 

Any reason why these arent pulled in?

-- 
thanks and regards
Srikar

