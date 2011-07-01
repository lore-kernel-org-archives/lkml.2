Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1GAVBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:01:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46963 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab1GAVBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:01:08 -0400
Date: Fri, 1 Jul 2011 23:00:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Will Drewry <wad@chromium.org>
Cc: James Morris <jmorris@namei.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, rostedt@goodmis.org,
        fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110701210011.GA22171@elte.hu>
References: <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
 <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
 <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
 <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
 <20110701115600.GK20990@elte.hu>
 <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
 <20110701130705.GG12605@elte.hu>
 <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
 <20110701161027.GA29035@elte.hu>
 <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Will Drewry <wad@chromium.org> wrote:

> On Fri, Jul 1, 2011 at 11:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> > But that's exactly my point: i consider it the right way forward 
> > because it maximizes kernel utility in the long run.
> 
> Not if it never happens.  Which is what happened with the proposals 
> from Adam and from Eric.

Well, that's what my job is as a maintainer: to tell you if i dislike 
a solution and to suggest better solutions - and here this was really 
easy to do, as you already prototyped a solution i consider (far) 
superior.

I cannot force you to do it like that, but i do have to say 'no'.

> > are not some bad side effect or quirk, they are all generic 
> > improvements we want in any case and not just for sandboxing.
> 
> I didn't say they were bad side effects or quirks.

That's a pretty important point as well.

> > You might not be interested in all of those items, you are only 
> > interested in getting the narrow feature-set you are interested 
> > in, but you sure are interested in getting sandboxing versus not 
> > getting anything at all, right?
> 
> Unfortunately, that isn't the value proposition for me or many 
> other contributors.  The real question is whether I am interested 
> in getting sandboxing in with mainline or if I want to sign up to 
> maintain the patches out of tree until my hair falls out.

Well, if you implement the right solution then why should it stay out 
of tree?

If the code is clean and useful and resolves all the technical 
objections that were raised against it then i will certainly merge it 
- and i hope Linus will chime in if he finds the actual iteration 
unacceptable and the direction harmful, to save us all the trouble.

In the end the 'sandboxing' feature should be a few dozen lines at 
most - all the rest will just be shared infrastructure.

Thanks,

	Ingo
