Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab2CZSxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:53:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab2CZSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:53:32 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=NFM--E4xPHYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=m3rNscxq_2rgUerDx74A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332788008.23924.114.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        torvalds@linux-foundation.org
Date: Mon, 26 Mar 2012 14:53:28 -0400
In-Reply-To: <20120326183232.GK2450@linux.vnet.ibm.com>
References: <20120325205249.GA29528@linux.vnet.ibm.com>
	 <1332748484.16159.61.camel@twins>
	 <20120326183232.GK2450@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 11:32 -0700, Paul E. McKenney wrote:

> Preemption is disabled at this point, correct?
> 
Is this a philosophical question? You're asking if preemption is
disabled while a task is currently being preempted ;-)

-- Steve


