Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0FOGes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:34:48 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47351 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab0FOGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:34:47 -0400
Date: Tue, 15 Jun 2010 12:02:46 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Roland McGrath <roland@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 1/14] X86 instruction analysis: Move Macro W to
 insn.h
Message-ID: <20100615063246.GF13800@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082803.29068.41025.sendpatchset@localhost6.localdomain6>
 <20100614173926.GA23754@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100614173926.GA23754@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2010-06-14 13:39:26]:

> On Mon, Jun 14, 2010 at 01:58:03PM +0530, Srikar Dronamraju wrote:
> > move_W_to_insn.patch
> > 
> > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > 
> > Move Macro W to asm/insn.h
> > 
> > Macro W used to know if the instructions are valid for
> > user-space/kernel space.  This macro is used by kprobes and
> > user_bkpt. (i.e user space breakpoint assistance layer.) So moving it
> > to a common header file asm/insn.h.
> 
> I don't think W is a good name for a macro in a header file.

Agree, Masami has also given the same comment earlier, I plan to move to
using inat tables instead of this macro. 

--
Thanks and Regards
Srikar
