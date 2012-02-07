Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2BGQJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:09:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab2BGQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:09:05 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=JW920i4TZMwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=cfIgjFGOJiRSeg59BDYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328630942.2200.80.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/3][RFC] tracing/rcu: Add _rcuidle() tracepoint to
 handle rcu_idle_exit() tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 07 Feb 2012 11:09:02 -0500
In-Reply-To: <20120207153710.GQ5941@linux.vnet.ibm.com>
References: <20120207145653.829892056@goodmis.org>
	 <20120207153710.GQ5941@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 07:37 -0800, Paul E. McKenney wrote:

> Please note that the __rcudle() tracepoints depend on patch #45 from
> my series (https://lkml.org/lkml/2012/2/3/471), though only for code
> containing tracepoints that are called both from idle and non-idle.
> I believe that the tracepoints in this patch series are only invoked
> from idle, so should be no problem.

Right, as I tested these without your patch series.

-- Steve


