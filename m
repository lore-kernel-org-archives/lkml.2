Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab0DHQqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:46:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39094 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758745Ab0DHQqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:46:20 -0400
Date: Thu, 8 Apr 2010 09:46:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/urgent] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100408164615.GA4836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100407171342.GF2481@linux.vnet.ibm.com>
 <20100407162620.GA11543@linux.vnet.ibm.com>
 <27310.1270659627@redhat.com>
 <27837.1270660848@redhat.com>
 <20100407230009.GK2481@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407230009.GK2481@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 04:00:09PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 07, 2010 at 06:20:48PM +0100, David Howells wrote:
> > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > In other cases, there will be a reference counter or a "not yet fully
> > > initialized" flag that can (and should) be tested.
> > 
> > Why would you be using rcu_access_pointer() there?  Why wouldn't you be using
> > rcu_dereference_protected()?
> 
> Excellent question.  I am writing up the documentation now, and will
> either (1) have a good use case or (2) remove the condition.

And all of the examples I could come up with that had c!=1 were contorted,
even by my standards.  So you were right, and I will drop the "c" on my
next set of patches.

							Thanx, Paul
