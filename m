Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2BVNe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:34:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab2BVNe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:34:27 -0500
Date: Wed, 22 Feb 2012 14:34:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222133404.GA14085@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120222065016.GA16923@elte.hu>
 <4F44934B.2000808@zytor.com>
 <20120222072538.GA17291@elte.hu>
 <4F449ACF.3040807@zytor.com>
 <20120222074839.GA24890@elte.hu>
 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
 <20120222080659.GA25318@elte.hu>
 <1329916920.25686.79.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329916920.25686.79.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> I like the blue shed, but anyway...
> 
> On Wed, 2012-02-22 at 09:06 +0100, Ingo Molnar wrote:
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> > > Not arguing that, but the static aspect is still key... or 
> > > people will read it as another version of likely/unlikely.  
> > 
> > They can *read* it as such, that as is very much intentional! 
> 
> I mentioned this thread on irc and the first comment I received was:
> 
> "is that a new attempt at trying to guide the compiler?"

It essentially is, implemented partly via compiler help, 
combined with runtime code patching, as an extended run-time arm 
of the compiler in essence, to make out of line slowpaths even 
cheaper to have around - to make the fast-path even faster.

> I personally find the very_unlikely() confusing, but then 
> again I like the blue shed over the pink one.

Confusing in what way?

Thanks,

	Ingo
