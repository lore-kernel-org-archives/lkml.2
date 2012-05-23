Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab2EWJlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:41:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EWJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:41:31 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FcrDmSi3BesA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VnNF1IyMAAAA:8 a=NY1iKCa1Vk0nJdF9DcAA:9 a=PUjeQqilurYA:10 a=sM8zq8rIUzIuwB8i:21 a=Zs9-G71WPAFmjt_v:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337766088.13348.146.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/3] tracing: Provide traceevents interface for uprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Date: Wed, 23 May 2012 05:41:28 -0400
In-Reply-To: <1337764783.13348.142.camel@gandalf.stny.rr.com>
References: <20120403010442.17852.9888.sendpatchset@srdronam.in.ibm.com>
	 <20120403010502.17852.58528.sendpatchset@srdronam.in.ibm.com>
	 <1337764783.13348.142.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 05:19 -0400, Steven Rostedt wrote:
> On Tue, 2012-04-03 at 06:35 +0530, Srikar Dronamraju wrote:
> > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > 
> > Implements trace_event support for uprobes. In its current form it can
> > be used to put probes at a specified offset in a file and dump the
> > required registers when the code flow reaches the probed address.
> > 
> > The following example shows how to dump the instruction pointer and %ax
> > a register at the probed text address.  Here we are trying to probe
> > zfree in /bin/zsh
> > 
> 
> Masami,
> 
> Can you ack this patch as well (only if you agree)
> 

Ignore this too, sorry for the noise. This is what I get for trying to
do work while struggling with insomnia :-p

-- Steve


