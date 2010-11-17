Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab0KQVlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:41:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0KQVlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:41:49 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=meSPosxfOXMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=axhC6xjIkjLpN2os58EA:9 a=Ol7n5Qa_oRyoAo1zIvcA:7 a=NJGia3KZCVGQcF-kJn6drx4pJtkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Benchmarks of kernel tracing options 2 (ftrace, lttng and perf)
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Santos <douglas.santos@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
        David Sharp <dhsharp@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
In-Reply-To: <1290029498.4ce449ba1679d@www.imp.polymtl.ca>
References: <1290029498.4ce449ba1679d@www.imp.polymtl.ca>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 16:41:46 -0500
Message-ID: <1290030106.30543.74.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 16:31 -0500, Douglas Santos wrote:
> Hi all,
> 
> This is a response to a benchmark, submitted a few weeks ago, comparing kernel
> tracing options.
> http://lkml.org/lkml/2010/10/28/422
> 
> We followed the methodology described in the link bellow,
> but using the shellscripts posted there to reproduce autotest scripts.
> http://lkml.org/lkml/2010/10/28/261
> 
> We disabled the extra syscall tracing on lttng, for a fair comparison.
> http://lkml.org/lkml/2010/10/28/290
> 
> Average results with tracing "on":
> 
> lttng:  220 ns
> ftrace: 260 ns

Heh, so ftrace got worse with the new kernel?

-- Steve

> perf:   740 ns
> 
> 
> E5405 system
> kernel 2.6.36
> 
> -lttng 0.239 + 0.19.2modules + sys_getuid tracepoint + sys_getuid probe
>  + remove syscall_trace
> 
> -ftrace and perf + sys_getuid tracepoint


