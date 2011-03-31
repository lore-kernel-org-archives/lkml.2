Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab1CaBWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:22:05 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39048 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1CaBWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:22:02 -0400
Date: Wed, 30 Mar 2011 18:21:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110331012155.GZ2255@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D924FEE.8040804@linux.intel.com>
 <20110329214704.GM2261@linux.vnet.ibm.com>
 <4D9256AF.5000308@linux.intel.com>
 <20110330004725.GO2261@linux.vnet.ibm.com>
 <4D92BECA.50802@cn.fujitsu.com>
 <4D92DA32.2010809@cn.fujitsu.com>
 <20110330105505.GA3195@sepie.suse.cz>
 <1301482656.4859.171.camel@twins>
 <4D931814.9090100@suse.cz>
 <4D93D29C.5010702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D93D29C.5010702@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 09:02:20AM +0800, Lai Jiangshan wrote:
> On 03/30/2011 07:46 PM, Michal Marek wrote:
> > On 30.3.2011 12:57, Peter Zijlstra wrote:
> >> On Wed, 2011-03-30 at 12:55 +0200, Michal Marek wrote:
> >>> Subject: [PATCH] headers: Allow for lightweight inclusion of task_struct definition
> >>>
> >>> Factor out a couple of type definitions to <header>_types.h to allow
> >>> using task_struct without pulling tons of new dependencies via sched.h.
> >>
> >> Urgh, not pretty.. so why not clean up sched.h properly? There's way too
> >> much cruft in there.
> > 
> > It was a proof-of-concept to show that it is doable to have proper
> > definition of task_struct in rcupdate.h. Not an entry for any code
> > beauty contest.
> > 
> > Michal
> > 
> 
> I like this cleanup, could you continue for this hard job? I will help you if required.
> 
> Ingo & Peter - will you accept the patches when it is done.
> 
> Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

I certainly like the idea of being able to inline TREE_PREEMPT_RCU's
rcu_read_lock() and rcu_read_unlock() using normal C code!

							Thanx, Paul
