Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033Ab0EMPXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:23:54 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35681 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0EMPXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:23:51 -0400
Date: Thu, 13 May 2010 08:23:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC tip/core/rcu 23/23] vhost: add __rcu annotations
Message-ID: <20100513152340.GA2879@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100512213317.GA15085@linux.vnet.ibm.com>
 <1273700022-16523-23-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100512214847.GD22930@redhat.com>
 <20100512230057.GH2303@linux.vnet.ibm.com>
 <1273756043.5605.3542.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273756043.5605.3542.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 03:07:23PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-12 at 16:00 -0700, Paul E. McKenney wrote:
> > Any thoughts?  One approach would be to create a separate lockdep class
> > for vhost workqueue state, similar to the approach used in instrument
> > rcu_read_lock() and friends. 
> 
> workqueue_struct::lockdep_map, its held while executing worklets.
> 
> lock_is_held(&vhost_workqueue->lockdep_map), should do as you want.

Thank you, Peter!!!

							Thanx, Paul
