Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2BVNWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:22:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2BVNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:22:04 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=oGMlB6cnAAAA:8 a=GcKRqP6ejnFNZsdXHHoA:9 a=PUjeQqilurYA:10 a=CY6gl2JlH4YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329916920.25686.79.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 08:22:00 -0500
In-Reply-To: <20120222080659.GA25318@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
	 <4F43F9F0.4000605@zytor.com> <20120222065016.GA16923@elte.hu>
	 <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu>
	 <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu>
	 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
	 <20120222080659.GA25318@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the blue shed, but anyway...

On Wed, 2012-02-22 at 09:06 +0100, Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Not arguing that, but the static aspect is still key... or 
> > people will read it as another version of likely/unlikely.  
> 
> They can *read* it as such, that as is very much intentional! 

I mentioned this thread on irc and the first comment I received was:

"is that a new attempt at trying to guide the compiler?"

I personally find the very_unlikely() confusing, but then again I like
the blue shed over the pink one.

-- Steve


