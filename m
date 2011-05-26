Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab1EZMbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:31:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58029 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1EZMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:31:46 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=Tf6TZck48twA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=o_ERWLc8tyXGTIoo-Q0A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH -tip ] [BUGFIX]tracing/kprobes: Fix kprobe-tracer to
 support stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        yrl.pp-manager.tt@hitachi.com, Russell King <rmk@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <BANLkTinMH_tsESVqN=dJZgpEncpYyDMHzQ@mail.gmail.com>
References: <20110512102255.2540.88867.stgit@ltc-x64-VirtualBox>
	 <1306375622.1465.137.camel@gandalf.stny.rr.com>
	 <BANLkTinMH_tsESVqN=dJZgpEncpYyDMHzQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 26 May 2011 08:31:43 -0400
Message-ID: <1306413103.1465.142.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 01:25 -0400, Mike Frysinger wrote:

> >  save_stack_trace_regs() function.
> 
> i think only x86 implements that func ? 

Looks to be the case. I didn't think so because not all archs failed.
Hmm, archs like sparc compiled. Perhaps my config prevented tracing
enabled? I'll need to take a deeper look.


>  and its stacktrace.c just seems to beg for generalization ...

Looks like a project for the next merge window :)

-- Steve


