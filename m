Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2BVVjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:39:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29613 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2BVVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:39:19 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=vkEQBy3kOgIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=l9_pDDdehqKnsUfYWnwA:9 a=p4yTYIZS9S6EPV8TmtkA:7 a=PUjeQqilurYA:10 a=rbc8e87uO9GgayyL:21 a=mDZ4xaxM__jPupO7:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329946755.25686.120.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/3 RFC paul/rcu/srcu] srcu: only increase the upper bit
 for srcu_read_lock()
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Date: Wed, 22 Feb 2012 16:39:15 -0500
In-Reply-To: <20120222212630.GA6759@linux.vnet.ibm.com>
References: <20120213020951.GA12138@linux.vnet.ibm.com>
	 <4F41F315.1040900@cn.fujitsu.com>
	 <20120220174418.GI2470@linux.vnet.ibm.com>
	 <4F42EF53.6060400@cn.fujitsu.com>
	 <20120221015037.GE2384@linux.vnet.ibm.com>
	 <4F435966.9020106@cn.fujitsu.com>
	 <20120221172442.GG2375@linux.vnet.ibm.com>
	 <4F44B57C.3020104@cn.fujitsu.com>
	 <20120222212056.GJ2416@linux.vnet.ibm.com>
	 <20120222212630.GA6759@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 13:26 -0800, Paul E. McKenney wrote:

> Make that without underflow -- one increment and 2^31+1 decrements would
> in fact return the counter to its original value, but that would require
> cramming more than two billion tasks into a 32-bit address space, which
> I believe to be sufficiently unlikely.  (Famous last words...)

I'll just expect to see you as President of the United States, counting
your money you won in the lottery, and being awarded a Nobel Prize for
curing cancer.

-- Steve



