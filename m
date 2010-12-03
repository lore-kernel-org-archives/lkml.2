Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab0LCOxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:53:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab0LCOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:53:14 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=urq4iAXTM6cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=TF-mqixJfSfayak_9k0A:9 a=Y92D6dloDdV7Qj4tCk4VoEICcBEA:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/2 v2] tracing: Add conditional to tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <20101203144720.GA1711@nowhere>
References: <20101203040358.955427199@goodmis.org>
	 <20101203144720.GA1711@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 09:53:12 -0500
Message-ID: <1291387992.3228.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 15:47 +0100, Frederic Weisbecker wrote:

> Looks good
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> I suspect we'll need to fix some scripts/subperf commands in perf. Those that do:
> 
> 	if (success)
> 
> tests after reading a trace from a wakeup event.

I  guess the question is, is that "success" part of the ABI or not?

-- Steve


