Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2BVS6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:58:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab2BVS6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:58:34 -0500
Date: Wed, 22 Feb 2012 13:58:10 -0500
From: Jason Baron <jbaron@redhat.com>
To: Richard Henderson <rth@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222185809.GI3405@redhat.com>
References: <4F449ACF.3040807@zytor.com>
 <20120222074839.GA24890@elte.hu>
 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
 <20120222080659.GA25318@elte.hu>
 <1329916920.25686.79.camel@gandalf.stny.rr.com>
 <20120222133404.GA14085@elte.hu>
 <1329918881.25686.92.camel@gandalf.stny.rr.com>
 <1329923583.24994.21.camel@twins>
 <1329924752.24994.25.camel@twins>
 <4F45226B.50606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F45226B.50606@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 09:14:19AM -0800, Richard Henderson wrote:
> On 02/22/12 07:32, Peter Zijlstra wrote:
> > So I clicked the link Jason provided in his 10/10 Documentation patch
> > and stumbled upon:
> > 
> >   http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01558.html
> > 
> > Where rth suggests that __attribute__((hot,cold)) might work on the
> > destination labels. Trying this my compiler (4.6.1+crap) pukes all over
> > me suggesting this isn't (yet) implemented.
> > 
> > Richard, is something like that still on the table?
> 
> It's still a possibility.  I gave Jason a patch for that quite some time
> ago; I don't recall hearing whether it turned out to actually be useful.
> 
> 
> r~

I don't think I ever quite got it working, and I've unfortunately
misplaced it at this point. I am definitely interested in trying it
again though. If you can re-send it, I'll try it.

Also, I think I seem to recall it wouldn't help the -Os case, b/c we
don't get block re-ordering?

Thanks,

-Jason
