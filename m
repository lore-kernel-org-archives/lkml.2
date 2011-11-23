Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1KWUwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:52:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:60325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1KWUwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:52:44 -0500
Message-ID: <1322081530.14799.97.camel@twins>
Subject: Re: [PATCH v7 3.2-rc2 5/30] uprobes: copy of the original
 instruction.
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Wed, 23 Nov 2011 21:52:10 +0100
In-Reply-To: <1322077748.20742.68.camel@frodo>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110733.10512.11835.sendpatchset@srdronam.in.ibm.com>
	 <1322073616.14799.96.camel@twins> <1322077748.20742.68.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 14:49 -0500, Steven Rostedt wrote:
> On Wed, 2011-11-23 at 19:40 +0100, Peter Zijlstra wrote:
> > On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > > +               /* TODO : Analysis and verification of instruction */
> > 
> > As in refuse to set a breakpoint on an instruction we can't deal with?
> > 
> > Do we care? The worst case we'll crash the program, but if we're allowed
> > setting uprobes we already have enough privileges to do that anyway,
> > right?
> 
> Well, I wouldn't be happy if I was running a server, and needed to
> analyze something it was doing, and because I screwed up the location of
> my probe, I crash the server, made lots of people unhappy and lose my
> job over it.
> 
> I think we do care, but it can be a TODO item.

But but but, why not let userspace sort it? And if you're going to
provide the kernel with inode:offset data yourself, you're already well
aware of wtf you're doing.


