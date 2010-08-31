Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0HaRhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 13:37:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab0HaRhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 13:37:05 -0400
Date: Tue, 31 Aug 2010 19:36:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Anton Blanchard <anton@samba.org>,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/trace_stack: Fix stack trace on ppc64
Message-ID: <20100831173653.GC29340@elte.hu>
References: <20100825013238.GE28360@kryten>
 <1283218310.1377.50.camel@gandalf.stny.rr.com>
 <20100831142111.GA5259@nowhere>
 <1283266722.1377.80.camel@gandalf.stny.rr.com>
 <20100831151439.GC5259@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831151439.GC5259@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Aug 31, 2010 at 10:58:42AM -0400, Steven Rostedt wrote:
> > Hmm, I never saw the tip-bot reply :-(
> > 
> > I guess it only sends to the Cc tags.
> > 
> > -- Steve
> > 
> > 
> 
> 
> We were in the commit Cc tags but somehow they didn't make it in the email
> tags.

indeed - i forwarded this to hpa.

	Ingo
