Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab2CITPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:15:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7636 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab2CITPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:15:01 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=LV9YWpXf9bAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=85a8RABxtJgHmxOi6i8A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331320498.25686.597.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] x86: use enum instead of literals for trap values
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Andy Lutomirski <luto@mit.edu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 09 Mar 2012 14:14:58 -0500
In-Reply-To: <20120309190842.GC13745@aftab>
References: <20120309074202.GA28609@www.outflux.net>
	 <20120309092845.GA10281@elte.hu>
	 <CAGXu5j+SgWMjwNQd8w8DPSQmBVHDow=_osp57OVp4X2VU5Fe5w@mail.gmail.com>
	 <4F5A448D.70605@zytor.com>
	 <CAGXu5jKHJGmTktKNYDmpZziKRLM-bw-dTK5tboR706J_s6j7NQ@mail.gmail.com>
	 <20120309182829.GA13745@aftab>
	 <CAGXu5jJaO29hqMfACav9v8yEdHXt-SegozGuc+tigYCF6K57WA@mail.gmail.com>
	 <20120309190842.GC13745@aftab>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 20:08 +0100, Borislav Petkov wrote:

> > Can use "VEC" instead "XCP", as Steven suggests.
> 
> Yeah, because those actually are fixed interrupt vectors, as they're
> called in the AMD docs. Makes sense.

I have to admit my bias may lean towards AMD's documentation as that's
the only x86_64 documentation I have/use. I don't know what Intel's
description is.

-- Steve


