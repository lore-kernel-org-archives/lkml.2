Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0CVGY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:24:56 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38031 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0CVGYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:24:54 -0400
Date: Mon, 22 Mar 2010 11:54:50 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/10] Move Macro W to insn.h
Message-ID: <20100322062450.GD30463@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142505.11427.30133.sendpatchset@localhost6.localdomain6>
 <4BA4EEAE.10202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4BA4EEAE.10202@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu <mhiramat@redhat.com> [2010-03-20 11:50:06]:

> Srikar Dronamraju wrote:
> > Move Macro W to asm/insn.h
> > 
> > Macro W used to know if the instructions are valid for
> > user-space/kernel space.  This macro is used by kprobes and
> > user_bkpt. (i.e user space breakpoint assistance layer.) So moving it
> > to a common header file asm/insn.h.
> 
> Hmm, I don't think this shortest macro name is good to expose
> commonly... And also, since we already have inat (instruction
> attribute) table, we'd better expand an inat bit to indicate
> which instruction can be probed/boosted.
> 

Guess we would need three bits, 
- Instruction can be probed in kernel.
- Instruction can be probed in user space.
- Instruction can be boosted.

Or do you have other ideas?

--
Thanks and Regards
Srikar
