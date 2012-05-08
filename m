Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2EHJUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:20:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60926 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2EHJUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:20:48 -0400
Date: Tue, 8 May 2012 11:20:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Subject: Re: [PATCH UPDATED 3/3] tracing: Provide trace events interface for
 uprobes
Message-ID: <20120508092041.GE27323@gmail.com>
References: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
 <20120409091154.8343.50489.sendpatchset@srdronam.in.ibm.com>
 <20120411103043.GB29437@linux.vnet.ibm.com>
 <20120508041229.GD30652@gmail.com>
 <1336465808.16236.13.camel@twins>
 <20120508085002.GA13272@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508085002.GA13272@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> * Peter Zijlstra <peterz@infradead.org> [2012-05-08 10:30:08]:
> 
> > On Tue, 2012-05-08 at 06:12 +0200, Ingo Molnar wrote:
> > > FYI, this warning started to trigger in -tip, with the latest 
> > > uprobes patches:
> > > 
> > > warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENTS && PERF_EVENTS)
> > 
> > this looks to be the only UPROBE_EVENTS instance, is that a typo?
> 
> 
> I think I corrected this in the latest posting I sent on April 16th.
> 
> Ingo,
> 
> 	Since you had asked me to send the patch series again 
> after handling comments and acks, I had sent the set. [...]

Mind sending a delta patch instead? The patches are now 
reasonably well tested and don't seem to break in any functional 
way, so unless the delta patch is really ugly we should try that 
instead of rebasing the branch.

Thanks,

	Ingo
