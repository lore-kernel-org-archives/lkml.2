Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2DNQwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:52:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59195 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2DNQwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:52:50 -0400
Date: Sat, 14 Apr 2012 09:52:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC 0/7] rcu: v2 Inlinable preemptible rcu_read_lock()
 and rcu_read_unlock()
Message-ID: <20120414165242.GG2452@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <CA+55aFw94CZOLu-DF03sXV5gt+JPNegoCt2agvaTfApr+ndmpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw94CZOLu-DF03sXV5gt+JPNegoCt2agvaTfApr+ndmpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-5518-0000-0000-000003AA7869
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 09:38:50AM -0700, Linus Torvalds wrote:
> On Sat, Apr 14, 2012 at 9:19 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > This series is version two of the inlinable versions of preemptible
> > RCU's __rcu_read_lock() and __rcu_read_unlock().
> 
> Btw, what is this supposed to apply on top of? It doesn't seem to
> apply cleanly to either v3.3, v3.4-rc[12], or current top-of-tree.
> 
> I can make it apply by reducing the context to just one line for
> patch#6, but your base seems to be odd.

My next step is to forward-port to 4.4-rc2, retest, and expose to -next.
The base is on top of the series that was pulled into the 4.4 merge window,
but on their base on top of 3.4-rc4.

I probably should have forward-ported before submitting, but I was so
happy about it finally actually passing a moderate version of the full
set of rcutorture tests that I just couldn't restrain myself.

							Thanx, Paul

