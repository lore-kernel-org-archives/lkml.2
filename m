Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2IFS3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:29:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45486 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2IFS3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:29:07 -0400
Message-ID: <1346956101.18408.61.camel@twins>
Subject: Re: [PATCH tip/core/rcu 13/23] rcu: Control grace-period duration
 from sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 20:28:21 +0200
In-Reply-To: <20120906175324.GN2448@linux.vnet.ibm.com>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-13-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346940930.18408.14.camel@twins>
	 <20120906175324.GN2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 10:53 -0700, Paul E. McKenney wrote:

> >  - how do I know if my workload wants a longer or shorter forced qs
> >    period?
> 
> Almost everyone can do just fine with the defaults.  If you have more
> than about 1,000 CPUs, you might need a longer period. 

Because the cost of starting a grace period is on the same order (or
larger) in cost as this period?

>  Some embedded
> systems might need a shorter period -- the only specific example I know
> of is network diagnostic equipment running wireshark, which starts up
> slowly due to grace-period length.

But but but 3 jiffies.. however is that too long?

> > Also, whatever made you want to provide this 'feature' in the first
> > place?
> 
> Complaints from the two groups called out above.

Does this really warrant a boot time knob for which even you cannot
quite explain what values to use when?


