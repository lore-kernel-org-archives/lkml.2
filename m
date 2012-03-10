Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab2CJO15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 09:27:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50858 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab2CJO1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 09:27:54 -0500
Date: Sat, 10 Mar 2012 15:27:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
Message-ID: <20120310142718.GA3966@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
	Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Andy Lutomirski <luto@mit.edu>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Frysinger <vapier@gentoo.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
 <4F5A448D.70605@zytor.com>
 <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
 <20120309182829.GA13745@aftab>
 <CAGXu5jJaO29hqMfACav9v8yEdHXt-SegozGuc+tigYCF6K57WA@mail.gmail.com>
 <20120309190842.GC13745@aftab>
 <4F5A644C.3080306@zytor.com>
 <1331324518.25686.606.camel@gandalf.stny.rr.com>
 <20120310101521.GA18106@liondog.tnic>
 <1331387676.25686.617.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1331387676.25686.617.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 08:54:36AM -0500, Steven Rostedt wrote:
> On Sat, 2012-03-10 at 11:15 +0100, Borislav Petkov wrote:
> > On Fri, Mar 09, 2012 at 03:21:58PM -0500, Steven Rostedt wrote:
> > > For the Linux made up ones, a more descriptive name is better. Then
> > > there wont be confusion when people look at "IR" and can't find it
> > > online or in the document, and scratch their head thinking they are not
> > > smart enough to do kernel development and we lose another kernel
> > > developer ;-)
> > 
> > Like that ever happens... Kernel developers have thick heads, in most
> > cases thicker than processor manuals.
> 
> I'm talking about new kernel developers, not the current ones ;-)

Yeah, this was more of an observation about what it takes to be a kernel
dude. Remember how off an on people appear on lkml asking what they
need to do in order to get involved in kernel development and how other
people go off in trying to be super helpful recite down all the newbie
docs and TODOs?

Well, my answer in such cases would rather be "grow a fat, thick head
and leave your emotions behind the corner - then you can stare on
hardware manuals and try to understand the code all you want!"

:-)

Oh well, enough bullshit...

-- 
Regards/Gruss,
    Boris.
