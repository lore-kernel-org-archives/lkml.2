Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988Ab0D3Xrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 19:47:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36742 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0D3Xrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 19:47:42 -0400
Date: Fri, 30 Apr 2010 16:47:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] fix several lockdep splats, allow
 multiple splats
Message-ID: <20100430234736.GA22669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100421200150.GA3818@linux.vnet.ibm.com>
 <20100430100749.GC14202@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430100749.GC14202@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 12:07:49PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello!
> > 
> > This patchset contains four RCU lockdep splat fixes, courtesy of David 
> > Howells, Peter Zijlstra, and Trond Myklebust, [...]
> 
> I've applied #1 and #2 - but shouldnt #4 and #5 go via the NFS tree?

Good point -- I will forward them on to Trond.

							Thanx, Paul
