Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0DLUwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:52:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41042 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0DLUwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:52:53 -0400
Date: Mon, 12 Apr 2010 13:52:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Triplett <josh@joshtriplett.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH tip/core/urgent 1/4] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100412205244.GE2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1270792042-9358-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100409165735.GB2421@linux.vnet.ibm.com>
 <20100412192441.GB27341@feather>
 <201004122230.43053.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004122230.43053.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 10:30:42PM +0200, Arnd Bergmann wrote:
> On Monday 12 April 2010 21:24:42 Josh Triplett wrote:
> > If you want to prevent people from deferencing the pointer directly, or
> > from assigning it to some other pointer, you could use Sparse's
> > __attribute__((noderef)) and
> > __attribute__((address_space(...)).
> > 
> > See the definitions of __user and __iomem in include/linux/compiler.h
> > for instance.  (And, looking at that file, now __percpu.  Nice!)
> > 
> > You'd then have to explicitly use __force at the point where you
> > legitimately dereference it.
> 
> I have started a patch set for doing that a few weeks ago, still need
> to pick up that work again. Are there any other patches besides this
> series that I should base on top of now?

Very good, Arnd!!!  Looking forward to seeing the updated patchset!!!

My suggestion would be to take the current tip/core/urgent, apply
this patch set, and start from there.

						Thanx, Paul
