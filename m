Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2CJNyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 08:54:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12196 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2CJNyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 08:54:40 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=LV9YWpXf9bAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=hs_wspsX514VuIXZtfwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331387676.25686.617.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sat, 10 Mar 2012 08:54:36 -0500
In-Reply-To: <20120310101521.GA18106@liondog.tnic>
References: <20120309074202.GA28609@www.outflux.net>
	 <20120309092845.GA10281@elte.hu>
	 <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
	 <4F5A448D.70605@zytor.com>
	 <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
	 <20120309182829.GA13745@aftab>
	 <CAGXu5jJaO29hqMfACav9v8yEdHXt-SegozGuc+tigYCF6K57WA@mail.gmail.com>
	 <20120309190842.GC13745@aftab> <4F5A644C.3080306@zytor.com>
	 <1331324518.25686.606.camel@gandalf.stny.rr.com>
	 <20120310101521.GA18106@liondog.tnic>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-10 at 11:15 +0100, Borislav Petkov wrote:
> On Fri, Mar 09, 2012 at 03:21:58PM -0500, Steven Rostedt wrote:
> > For the Linux made up ones, a more descriptive name is better. Then
> > there wont be confusion when people look at "IR" and can't find it
> > online or in the document, and scratch their head thinking they are not
> > smart enough to do kernel development and we lose another kernel
> > developer ;-)
> 
> Like that ever happens... Kernel developers have thick heads, in most
> cases thicker than processor manuals.

I'm talking about new kernel developers, not the current ones ;-)

-- Steve


