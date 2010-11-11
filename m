Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0KKCFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 21:05:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0KKCF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 21:05:29 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=oE26JRsOFGEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=zzA7KhYpfwU1aV524OgA:9 a=5lwSglha6nIPPW_YcoQA:7 a=odHVyv78gJY-4Jh9AEcY0KzFZHYA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFD tracing] Tracing ABI Work Plan
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Sharp <dhsharp@google.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1011110251580.2900@localhost6.localdomain6>
References: <20101111004612.GB32564@Krystal>
	 <alpine.LFD.2.00.1011110158390.2900@localhost6.localdomain6>
	 <1289440255.12418.218.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1011110251580.2900@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 21:05:27 -0500
Message-ID: <1289441127.12418.222.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 02:55 +0100, Thomas Gleixner wrote:
> On Wed, 10 Nov 2010, Steven Rostedt wrote:
> > On Thu, 2010-11-11 at 02:33 +0100, Thomas Gleixner wrote:
> > 
> > > Either that or you immediately install the "Work Plan Committee" which
> > > will make sure that there will be no progress ever.
> > 
> > Oooo ooo oo, I want to be on this committee!!!
> > 
> > Get Mathieu and I there, and we can guarantee no work will ever
> > happen ;-)
> 
> Hereby you and Mathieu are appointed to the "Work Plan Committee". By
> accepting that appointment you promise to stay away from real kernel
> tracing problems forever and restrict yourself to an annual "no
> progress" report.
> 
> Thanks,
> 
> 	tglx
> ---
> P.S.: It would be more funny, if it wouldn't be close to reality!

So be it...

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0094224..96850d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5889,7 +5889,6 @@ S:	Maintained
 F:	drivers/char/tpm/
 
 TRACING
-M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Frederic Weisbecker <fweisbec@gmail.com>
 M:	Ingo Molnar <mingo@redhat.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf/core


