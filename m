Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab0DHTyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:54:01 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57114 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0DHTx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:53:59 -0400
Date: Thu, 8 Apr 2010 12:53:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/urgent] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100408195350.GB2520@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100408164615.GA4836@linux.vnet.ibm.com>
 <20100407171342.GF2481@linux.vnet.ibm.com>
 <20100407162620.GA11543@linux.vnet.ibm.com>
 <27310.1270659627@redhat.com>
 <27837.1270660848@redhat.com>
 <20100407230009.GK2481@linux.vnet.ibm.com>
 <12448.1270753447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12448.1270753447@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 08:04:07PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > And all of the examples I could come up with that had c!=1 were contorted,
> > even by my standards.  So you were right, and I will drop the "c" on my
> > next set of patches.
> 
> :-)
> 
> When it's done, I'll rebuild my keys and NFS patches on top of it.

Testing in progress.  ;-)

							Thanx, Paul
