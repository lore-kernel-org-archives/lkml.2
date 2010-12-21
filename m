Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0LUH6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:58:38 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35071 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab0LUH6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:58:37 -0500
Date: Mon, 20 Dec 2010 23:58:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase
 synchronize_sched_expedited() batching
Message-ID: <20101221075828.GJ2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101217205433.GA10199@linux.vnet.ibm.com>
 <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D0CDD93.7040907@kernel.org>
 <20101218201419.GD2143@linux.vnet.ibm.com>
 <4D0DD3D2.4030606@kernel.org>
 <1292841080.2708.134.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292841080.2708.134.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 11:31:20AM +0100, Peter Zijlstra wrote:
> On Sun, 2010-12-19 at 10:43 +0100, Tejun Heo wrote:
> > 
> > I see, then would something like the following work?
> > 
> >  (int)((unsigned)(a) - (unsigned)(b)) < 0 
> 
> Note that there is lots of kernel code that does the above and
> variations thereof and expects it to work.

Given that the approach I have been using is the same number of lines
and avoids relying on this expectation, I will stick with it.

							Thanx, Paul
