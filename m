Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2AQTxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:53:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2AQTxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:53:00 -0500
X-Authority-Analysis: v=2.0 cv=Hf6Wv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=KHR86nk1PkcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Spp0eDKftHELShrFBo0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326829977.17534.65.camel@gandalf.stny.rr.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 17 Jan 2012 14:52:57 -0500
In-Reply-To: <20120117100222.GH10397@elte.hu>
References: <20120110174509.GA30802@redhat.com>
	 <20120113182015.GA3902@redhat.com> <20120115182441.GA24694@redhat.com>
	 <20120116074540.GE15641@elte.hu>
	 <1326717070.7642.144.camel@gandalf.stny.rr.com>
	 <20120116125329.GB31667@elte.hu>
	 <1326729123.7642.146.camel@gandalf.stny.rr.com>
	 <20120117100222.GH10397@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 11:02 +0100, Ingo Molnar wrote:
>  
> > The kernel does this all the time. We have syscalls that may 
> > extend the data structure. [...]
> 
> That is not true *AT ALL* in such an unqualified manner. Steve, 
> stop being stupid.

OK, Ingo I think we had a little miscommunication here.

I forgot what I originally wrote, and you cut off too much in your
reply. What I originally said:


"The kernel does this all the time. We have syscalls that may extend the
data structure. This is a common practice. Any app that depends on a
data structure remaining the same size for no good reason is broken by
design."

If you took the "Any app that depends on a data structure remaining the
same size for no good reason is broken by design" was suppose to mean,
any app that depends on syscall data structures is broken by design, I
would agree, that statement is stupid. I didn't write that well, as my
thought process switched back to reading tracepoints and wasn't meant to
be about syscalls there. I didn't articulate that properly.

As you can tell, I was a little upset at being called stupid this
morning. If you took that statement to mean about syscalls, I understand
your calling me stupid, and I apologize for being a bit snippy. I like
to keep LKML discussions technical and not something for name calling.

-- Steve


