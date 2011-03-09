Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab1CIAOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:14:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab1CIAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:14:19 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=KpzchuzAFZgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SQUREDfjPc81AOHo7vgA:9 a=U0RwUkSzpZnA77j_QQtcISW_4hIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
In-Reply-To: <20110309000753.GA27729@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	 <20110308232258.GA25987@Krystal>
	 <1299627175.20306.96.camel@gandalf.stny.rr.com>
	 <20110309000753.GA27729@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 19:14:17 -0500
Message-ID: <1299629657.20306.105.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 19:07 -0500, Mathieu Desnoyers wrote:

> So what you are saying here is that modifying /etc/modprobe.d/ is the actual
> interface you propose presenting to the end-users to control their tracepoints ?

If you want to have them enabled on boot, sure.

> Maybe I am missing something, but this interface seems to lack the layer of
> finish we might want to put into a user-visible API. I don't really see how
> distributions can hope to automate any of this for their end-user without making
> a mess of the /etc/modprobe.d/ they ship with.

What distros enable tracepoints by default?

If you want to enable a tracepoint on module load simply do:

 modprobe mymod trace_my_tracepoint=1

Otherwise modify your modprobe.d directory. This is the way users have
been doing module parameters for years.

That's pretty simple to me.

-- Steve


