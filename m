Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1IPNXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:23:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1IPNXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:23:44 -0400
X-Authority-Analysis: v=1.1 cv=hYZYwEn6AKazWLoXuCKKTQjUqAdcGu6fIqD+Oh7rMYo= c=1 sm=0 a=Ou53dPJkDmsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=TQpZSZvmDLXGtzDsXlMA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] ftrace:  use a global counter for the global clock
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1316176603.10174.24.camel@twins>
References: <1316163765.10174.8.camel@twins>
	 <1316175506.26295.36.camel@gandalf.stny.rr.com>
	 <1316176603.10174.24.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 16 Sep 2011 09:23:41 -0400
Message-ID: <1316179421.26295.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 14:36 +0200, Peter Zijlstra wrote:
> On Fri, 2011-09-16 at 08:18 -0400, Steven Rostedt wrote:
> > +       return atomic64_add_return(1, &trace_counter);
> 
> Oh, fwiw I modified mine to increment by 1000 because we're showing us
> in the trace output, 1000 lines with the same 'time'-stamp is slightly
> confusing even though you know the order is absolutely right...


Or I could change it so that if counter clock is set, just show that
field as a counter too.

-- Steve


