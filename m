Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2DPJ27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:28:59 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54463 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2DPJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:28:57 -0400
Date: Mon, 16 Apr 2012 14:50:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [Updated PATCH 3/3] tracing: Provide trace events interface
 for uprobes
Message-ID: <20120416092054.GC13363@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120413112941.16602.69097.sendpatchset@srdronam.in.ibm.com>
 <4F8902BF.6070801@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F8902BF.6070801@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041609-2398-0000-0000-000005D93556
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> >  config UPROBES
> >  	bool "Transparent user-space probes (EXPERIMENTAL)"
> > -	depends on ARCH_SUPPORTS_UPROBES && PERF_EVENTS
> > +	depends on UPROBE_EVENTS && PERF_EVENTS
> 
> Is it UPROBE_EVENTS or UPROBE_EVENT?

Yes, I corrected it in the version that I sent out just now. 
Thanks for pointing this out.


-- 
Thanks and Regards
Srikar

