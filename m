Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0LHOEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:04:02 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0LHOEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:04:00 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=1rL68P45qlwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7d_E57ReAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=ZE8Ea1FEOYyvg3EX_MEA:9 a=Jw4Rpx7XZtQnEsDW_pl71MLwIYgA:4 a=PUjeQqilurYA:10 a=D6-X0JM3zdQA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/4] tracing: Add TRACE_EVENT_CONDITIONAL()
From: Steven Rostedt <rostedt@goodmis.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101208155703.173C.A69D9226@jp.fujitsu.com>
References: <20101204021744.521599148@goodmis.org>
	 <20101204023141.552849493@goodmis.org>
	 <20101208155703.173C.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 08 Dec 2010 09:03:56 -0500
Message-ID: <1291817036.5015.861.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 15:56 +0900, KOSAKI Motohiro wrote:

> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Arjan van de Ven <arjan@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> I love this patch. thanks, Steven :)

I can add your Acked-by: then?

-- Steve



