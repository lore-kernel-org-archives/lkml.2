Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1FNPFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:05:03 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58236 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1FNPFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:05:01 -0400
Date: Tue, 14 Jun 2011 20:27:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 2/22]  2: uprobes: Breakground page
 replacement.
Message-ID: <20110614145706.GD4952@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125835.28590.25476.sendpatchset@localhost6.localdomain6>
 <1307660609.2497.1773.camel@laptop>
 <20110613085955.GD27130@linux.vnet.ibm.com>
 <1308056249.19856.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1308056249.19856.34.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > /*
> >  * NOTE:
> >  * Expect the breakpoint instruction to be the smallest size instruction for
> >  * the architecture. If an arch has variable length instruction and the
> >  * breakpoint instruction is not of the smallest length instruction
> >  * supported by that architecture then we need to modify read_opcode /
> >  * write_opcode accordingly. This would never be a problem for archs that
> >  * have fixed length instructions.
> >  */
> 
> Whoever reads comments anyway? :-)
> 
> > Do we have archs which have a breakpoint instruction which isnt of the
> > smallest instruction size for that arch. If we do have can we change the
> > write_opcode/read_opcode while we support that architecture?
> 
> Why not put a simple WARN_ON_ONCE() in there that checks the assumption?

Okay, will do.

-- 
Thanks and Regards
Srikar
