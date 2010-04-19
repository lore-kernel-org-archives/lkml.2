Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0DSSdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:33:15 -0400
Received: from kroah.org ([198.145.64.141]:45582 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab0DSScl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:32:41 -0400
Date: Mon, 19 Apr 2010 11:28:22 -0700
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       stable <stable@kernel.org>
Subject: Re: [stable] [PATCH] modules fix incorrect percpu usage
Message-ID: <20100419182822.GH32347@kroah.com>
References: <20100330033211.GC7683@Krystal>
 <20100330033617.GE7683@Krystal>
 <1269955201.19685.5867.camel@gandalf.stny.rr.com>
 <20100330135047.GB20673@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330135047.GB20673@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:50:47AM -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Mon, 2010-03-29 at 23:36 -0400, Mathieu Desnoyers wrote:
> > > * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > > > Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> > > > for per cpu pointers).
> > > > 
> > > > Introduced by commit:
> > > > 
> > > > module.c: commit 6b588c18f8dacfa6d7957c33c5ff832096e752d3
> > > > 
> > > > This patch should be queued for the stable branch, for kernels 2.6.29.x to
> > > > 2.6.33.x.
> > > > (tested on 2.6.33.1 x86_64)
> > > 
> > > It's actually needed for mainline too (2.6.34-rc2).
> > 
> > Then all you need to do is submit it for mainline with a 
> > "Cc: stable@kernel.org" as you did below. It will then automatically be
> > added to the stable queue when Linus pulls it.
> 
> OK, thanks for the info.

And I need to wait until it goes into Linus's tree before it can be
applied to the stable tree.  This hasn't happened yet, right?

thanks,

greg k-h
