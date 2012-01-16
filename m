Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2APPwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:52:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2APPwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:52:06 -0500
X-Authority-Analysis: v=2.0 cv=Hf6Wv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KHR86nk1PkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hsdAIpbaL-OQDLbZCG8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326729123.7642.146.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 16 Jan 2012 10:52:03 -0500
In-Reply-To: <20120116125329.GB31667@elte.hu>
References: <20120110174509.GA30802@redhat.com>
	 <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com>
	 <20120116074540.GE15641@elte.hu>
	 <1326717070.7642.144.camel@gandalf.stny.rr.com>
	 <20120116125329.GB31667@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 13:53 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> Say if an app relies on the smaller data structure, it sure 
> might get surprised by the kernel writing a wider record ...

Ingo,

The kernel does this all the time. We have syscalls that may extend the
data structure. This is a common practice. Any app that depends on a
data structure remaining the same size for no good reason is broken by
design.

Now we are making tracepoints stricter than system calls?

I'm starting to regret adding the whole TRACE_EVENT() interface.

-- Steve


