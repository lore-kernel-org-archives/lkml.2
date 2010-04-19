Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab0DSSc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:32:58 -0400
Received: from kroah.org ([198.145.64.141]:45595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0DSScl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:32:41 -0400
Date: Mon, 19 Apr 2010 11:29:36 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH] lockdep fix incorrect percpu usage
Message-ID: <20100419182936.GI32347@kroah.com>
References: <20100330033425.GD7683@Krystal>
 <1269938876.5109.510.camel@twins>
 <20100330134555.GA20673@Krystal>
 <1269959111.5258.142.camel@laptop>
 <20100330150551.GA22312@Krystal>
 <4BB2B6C4.8090803@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB2B6C4.8090803@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:43:16AM +0900, Tejun Heo wrote:
> On 03/31/2010 12:05 AM, Mathieu Desnoyers wrote:
> > I see. These patches are "on their way" to mainline, so it's better not to
> > create conflicts. So the lockdep patch should only be applied to -stable, but
> > separate module.c patch should apply to both -stable and mainline. Am I
> > correct ?
> 
> I'll push proper fixes to mainline in a few days.  For -stable, yeah,
> probably.

Ok, did a patch ever end up in Linus's tree for this that I can pull
into the -stable releases?

thanks,

greg k-h
