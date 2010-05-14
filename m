Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab0ENUaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:30:46 -0400
Received: from kroah.org ([198.145.64.141]:40804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0ENUag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:30:36 -0400
Date: Fri, 14 May 2010 13:16:40 -0700
From: Greg KH <greg@kroah.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH RFC tip/core/rcu 06/11] staging: remove all rcu head
 initializations
Message-ID: <20100514201640.GA25174@kroah.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
 <1273620786-20392-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100511234523.GA1450@suse.de>
 <20100512000821.GH2336@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512000821.GH2336@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 05:08:21PM -0700, Paul E. McKenney wrote:
> On Tue, May 11, 2010 at 04:45:23PM -0700, Greg KH wrote:
> > On Tue, May 11, 2010 at 04:33:01PM -0700, Paul E. McKenney wrote:
> > > Remove all rcu head inits. We don't care about the RCU head state before passing
> > > it to call_rcu() anyway. Only leave the "on_stack" variants so debugobjects can
> > > keep track of objects on stack.
> > > 
> > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > ---
> > >  drivers/staging/batman-adv/hard-interface.c |    1 -
> > 
> > Is this safe to apply to my tree now?  Or do you want to take it through
> > your tree as it depends on other stuff?
> 
> Because the rcu_head in this case is not in an auto (on-stack) variable,
> this commit is safe to apply to your tree now.
> 
> Let me know when you have applied it, and I will happily remove it
> from mine.  ;-)

Now queued up.

thanks,

greg k-h
