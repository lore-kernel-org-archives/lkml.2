Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab1FJF5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:57:14 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45174 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FJF5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:57:13 -0400
Date: Fri, 10 Jun 2011 11:26:48 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 0/22]  0: Uprobes patchset with perf
	probe support
Message-ID: <20110610055648.GA22707@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6> <1307644944.2497.1023.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307644944.2497.1023.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 08:42:24PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 18:28 +0530, Srikar Dronamraju wrote:
> > - Breakpoint handling should co-exist with singlestep/blockstep from
> >   another tracer/debugger.
> > - Queue and dequeue signals delivered from the singlestep till
> >   completion of postprocessing. 
> 
> These two are important to sort before we can think of merging this
> right?

Yup.

Guess Srikar missed updating this part, but the first of the issues
(sstep/blockstep) is now fixed. Signal queueing is a work-in-progress.

Ananth
