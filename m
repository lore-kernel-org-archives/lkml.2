Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1KWTtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:49:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1KWTtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:49:12 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=a_aNjojq4BQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=6R96RxJX0PxbPhCWiUoA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH v7 3.2-rc2 5/30] uprobes: copy of the original
 instruction.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
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
In-Reply-To: <1322073616.14799.96.camel@twins>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
	 <20111118110733.10512.11835.sendpatchset@srdronam.in.ibm.com>
	 <1322073616.14799.96.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 14:49:08 -0500
Message-ID: <1322077748.20742.68.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 19:40 +0100, Peter Zijlstra wrote:
> On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > +               /* TODO : Analysis and verification of instruction */
> 
> As in refuse to set a breakpoint on an instruction we can't deal with?
> 
> Do we care? The worst case we'll crash the program, but if we're allowed
> setting uprobes we already have enough privileges to do that anyway,
> right?

Well, I wouldn't be happy if I was running a server, and needed to
analyze something it was doing, and because I screwed up the location of
my probe, I crash the server, made lots of people unhappy and lose my
job over it.

I think we do care, but it can be a TODO item.

-- Steve


