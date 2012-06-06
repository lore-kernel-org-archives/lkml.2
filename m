Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2FFOq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:46:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2FFOq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:46:28 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=MiGSmKHM__4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=qba2GGtNHH2FiFtJR1sA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338993986.13348.549.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on
 i386
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 06 Jun 2012 10:46:26 -0400
In-Reply-To: <4FCF6B27.2020008@hitachi.com>
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
	 <20120605102802.27845.49309.stgit@localhost.localdomain>
	 <1338928666.13348.538.camel@gandalf.stny.rr.com>
	 <20120605212411.GC11575@redhat.com>
	 <1338939470.13348.541.camel@gandalf.stny.rr.com>
	 <20120605234133.GD11575@redhat.com> <4FCF6B27.2020008@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 23:37 +0900, Masami Hiramatsu wrote:

> I agree with Frank. Register restoring should be done as far as the
> ftrace is used for kprobes. Of course, one reason is for the fault
> injection, which is very useful for debugging system failure. And
> another technical reason is that we should do "optimization"
> transparently. IMHO, kprobes works normally doing something,
> optimized kprobes also should do so.
> 
> But if you introduce FTRACE_OPS_FL_RSTR_REGS flag for restoring
> registers, it could be possible to provide corresponding flag
> from kprobes side. (perhaps KPROBE_FLAG_NOMODREGS? :))

That's fine, my patch set restores the regs anyway.

-- Steve


