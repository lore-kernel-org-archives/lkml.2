Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0C3QtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:49:16 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45393 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0C3QtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:49:15 -0400
Date: Tue, 30 Mar 2010 09:49:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix RCU warnings in
 nfs_inode_return_delegation_noreclaim() [ver #2]
Message-ID: <20100330164912.GG2513@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100329210520.GN2569@linux.vnet.ibm.com>
 <20100329192159.GM2569@linux.vnet.ibm.com>
 <20100319022527.GC2894@linux.vnet.ibm.com>
 <20100318133302.29754.1584.stgit@warthog.procyon.org.uk>
 <19192.1269889348@redhat.com>
 <23274.1269893706@redhat.com>
 <25276.1269901350@redhat.com>
 <26760.1269903543@redhat.com>
 <20100329232636.GT2569@linux.vnet.ibm.com>
 <2440.1269967151@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2440.1269967151@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 05:39:11PM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Scrap this one -- Arnd has it covered, under the much better name
> > of rcu_dereference_const().
> 
> Not convinced of that name either.  That sounds like the RCU dereference of
> constant (R/O) data.

Which it is, as long as the lock is held.

But what name would you suggest?

							Thanx, Paul
