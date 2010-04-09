Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab0DIQ4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:56:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33311 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab0DIQ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:56:16 -0400
Date: Fri, 9 Apr 2010 09:56:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent 1/4] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100409165610.GA2421@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1270792042-9358-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100409054701.GA8833@linux.vnet.ibm.com>
 <23572.1270804211@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23572.1270804211@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 10:10:11AM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > +#define rcu_access_pointer(p) ((void *)ACCESS_ONCE(p))
> > ...
> > +#define rcu_access_pointer(p)		((void *)ACCESS_ONCE(p))
> 
> There's no difference between your two versions of rcu_access_pointer(), so
> you could move that whole construct outside of the #ifdef'ed section.
> 
> Other than that:
> 
> Acked-by: David Howells <dhowells@redhat.com>

Good point, will rework and resubmit.

							Thanx, Paul
