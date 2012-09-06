Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab2IFWMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:12:37 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44104 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2IFWMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:12:35 -0400
Date: Thu, 6 Sep 2012 15:11:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 14/15] time: RCU permitted to stop idle
 entry via softirq
Message-ID: <20120906221154.GP2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346944328.18408.34.camel@twins>
 <20120906213508.GG2448@linux.vnet.ibm.com>
 <1346968665.1680.56.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346968665.1680.56.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090622-9360-0000-0000-00000A4D8370
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 05:57:45PM -0400, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 14:35 -0700, Paul E. McKenney wrote:
> 
> > But yes, RCU was a lot simpler before people started worrying about
> > its energy efficiency.  ;-)
> 
> Tell them to buy bigger batteries.

If nuclear batteries are good enough for Curiosity, they are good enough
for you!!!  ;-)

							Thanx, Paul

