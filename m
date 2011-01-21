Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1AUR2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:28:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52039 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1AUR23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:28:29 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=iNkslzVf2eoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=E2cam0Y8KkeVXYp6xaIA:9 a=FnuHOF8ewbxLd5XQ-jzV9MUdmT0A:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH V2] tracing, perf : add cpu hotplug trace events
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org, amit.kucheria@linaro.org
In-Reply-To: <AANLkTinhX6UwQA0HFhuu5=jbq84woVhqtahuzA5hEo2o@mail.gmail.com>
References: <AANLkTinNoYbDe5huY4_Q6YidbWxqXqVWbVP2_7o-=P3W@mail.gmail.com>
	 <20110120161101.GA17218@nowhere>
	 <AANLkTinhX6UwQA0HFhuu5=jbq84woVhqtahuzA5hEo2o@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 21 Jan 2011 12:28:26 -0500
Message-ID: <1295630906.12215.4244.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 09:43 +0100, Vincent Guittot wrote:
> On 20 January 2011 17:11, Frederic Weisbecker <fweisbec@gmail.com> wrote:

> >
> >> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_start,
> >> +
> >> +     TP_PROTO(unsigned int cpuid),
> >> +
> >> +     TP_ARGS(cpuid)
> >> +);
> >> +
> >> +DEFINE_EVENT(cpu_hotplug, cpu_hotplug_arch_wait_die_end,
> >> +
> >> +     TP_PROTO(unsigned int cpuid),
> >> +
> >> +     TP_ARGS(cpuid)
> >> +);
> >
> > What is wait die, compared to die for example?
> >
> 
> The arch_wait_die is used to trace the process which waits for the cpu
> to die (__cpu_die) and the arch_die is used to trace when the cpu dies
> (cpu_die)

Shouldn't that be "cpu_hotplug_arch_task_wait_die" then? If it is a task
that is waiting?

-- Steve

> 
> > We need those tracepoints to be applied to get that reviewable in practice.
> >
> 
> Ok, I'm going to send a proposal
> 
> > Thanks.
> >


