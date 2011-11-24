Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1KXMvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:51:08 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:45013 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1KXMvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:51:06 -0500
Date: Thu, 24 Nov 2011 18:20:15 +0530
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
Subject: Re: [PATCH v7 3.2-rc2 5/30] uprobes: copy of the original
 instruction.
Message-ID: <20111124182015.4ef4b86a.srikar@linux.vnet.ibm.com>
In-Reply-To: <1322073616.14799.96.camel@twins>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	<20111118110733.10512.11835.sendpatchset@srdronam.in.ibm.com>
	<1322073616.14799.96.camel@twins>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 11112412-2000-0000-0000-0000043000A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 19:40:16 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > +               /* TODO : Analysis and verification of instruction
> > */
> 
> As in refuse to set a breakpoint on an instruction we can't deal with?
> 
> Do we care? The worst case we'll crash the program, but if we're
> allowed setting uprobes we already have enough privileges to do that
> anyway, right?
> 

I think we should and we do care. 
That's already implemented in the subsequent patches too.
For example: we don't a trace breakpoint instruction.

-- 
Thanks and Regards
Srikar

