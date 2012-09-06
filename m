Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab2IFUt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:49:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46760 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654Ab2IFUtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:49:24 -0400
Date: Thu, 6 Sep 2012 13:39:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] Add callback-free CPUs
Message-ID: <20120906203957.GW2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120905213945.GA15216@linux.vnet.ibm.com>
 <1346881720.2600.48.camel@twins>
 <20120905234443.GY3308@linux.vnet.ibm.com>
 <1346926417.2600.73.camel@twins>
 <20120906164745.GF2448@linux.vnet.ibm.com>
 <1346950736.18408.43.camel@twins>
 <20120906174652.GM2448@linux.vnet.ibm.com>
 <1346955710.18408.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346955710.18408.58.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090620-9360-0000-0000-00000A4CC7FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 08:21:50PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-06 at 10:46 -0700, Paul E. McKenney wrote:
> > Getting these
> > CPUs into adaptive-tick mode more quickly reduces OS jitter, which is
> > one big expected benefit of adaptive-tick mode. 
> 
> I'm not sure I agree with that statement. Its a transition thing and
> therefore statistically irrelevant on the whole -- assuming we
> transition rarely.
> 
> And for those who cannot deal with the transition effects, a barrier was
> proposed which would wait until the system hit this state -- although
> the specific implementation of this isn't clear yet afaik.
> 
> I very much think we should focus on getting adaptive tick working as
> simple as possible and worry about transition effects later, if at all.

I expect that the RT folks will be interested as well, and they will
likely care about the transition effects because they degrade worst-case
behavior.

							Thanx, Paul

