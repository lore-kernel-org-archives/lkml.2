Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2IFTyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:54:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32007 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2IFTyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:54:06 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jUoZk2RAzk0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xkD7W5DCUvkA:10 a=11dK3fG9OZgJlp-oYcEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346961244.1680.46.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 15:54:04 -0400
In-Reply-To: <20120906185402.GB5738@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20120831180052.GB4259@jtriplet-mobl1>
	 <20120904223350.GQ2593@linux.vnet.ibm.com>
	 <1346799082.27919.31.camel@gandalf.local.home>
	 <20120904230834.GB11494@jtriplet-mobl1>
	 <1346801031.27919.39.camel@gandalf.local.home>
	 <20120904233344.GB11855@jtriplet-mobl1>
	 <20120904234307.GY2593@linux.vnet.ibm.com>
	 <20120906185402.GB5738@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 11:54 -0700, Josh Triplett wrote:
> Not sure I see much difference in aesthetics between the three approaches,
> > but am willing to switch over to a generally agreed-upon scheme.
> 
> Steve, could I get an ack from you on the patch I sent?

I acked it, but do you just want me to take the patch? I'm getting ready
for another 3.7 push to tip.

-- Steve


