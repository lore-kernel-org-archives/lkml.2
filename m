Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1EQKu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:50:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47687 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1EQKu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:50:28 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=Tf6TZck48twA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=oBVUQWJ9soygs489iVoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH -tip ] [BUGFIX]tracing/kprobes: Fix kprobe-tracer to
 support stack trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4DD23590.4020200@hitachi.com>
References: <20110512102255.2540.88867.stgit@ltc-x64-VirtualBox>
	 <4DD23590.4020200@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 17 May 2011 06:50:25 -0400
Message-ID: <1305629425.5456.610.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 17:45 +0900, Masami Hiramatsu wrote:
> (2011/05/12 19:22), Masami Hiramatsu wrote:
> > Fix to support kernel stack trace correctly on kprobe-tracer.
> > Since the execution path of kprobe-based dynamic events is different
> > from other tracepoint-based events, normal ftrace_trace_stack() doesn't
> > work correctly. To fix that, this introduces ftrace_trace_stack_regs()
> > which traces stack via pt_regs instead of current stack register.
> 
> Hmm, any comments?
> 

Hi Masami,

I've been traveling, and I'm way behind in my email. I'll take a look at
this later today.

Thanks,

-- Steve


