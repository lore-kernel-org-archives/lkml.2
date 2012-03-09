Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab2CIWNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:13:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab2CIWNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:13:31 -0500
Date: Fri, 9 Mar 2012 23:13:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@amd64.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
Message-ID: <20120309221302.GA17158@elte.hu>
References: <20120309074202.GA28609@www.outflux.net>
 <20120309092845.GA10281@elte.hu>
 <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
 <4F5A448D.70605@zytor.com>
 <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
 <20120309182829.GA13745@aftab>
 <1331319124.25686.580.camel@gandalf.stny.rr.com>
 <4F5A63B3.1040509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5A63B3.1040509@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 03/09/2012 10:52 AM, Steven Rostedt wrote:
> > I agree too, except where does "XCP" come from? Is it short for
> > "exception"?
> 
> Yes, short for "exception".  I hate to admit it, but it comes from the
> constants we used in the Transmeta microcode ;)

Hm, were I to see 'X86_XCP_MC' for the first time I'd have no 
idea what it means. Really, lets not use random new 
abbreviations, lets use well-known patterns.

Make it X86_TRAP_XX, it's both short and correct?

Thanks,

	Ingo
