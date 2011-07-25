Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1GYT6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:58:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1GYT63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:58:29 -0400
Date: Mon, 25 Jul 2011 21:57:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][Trivial] Update version number reference to new 3.x
 scheme for EVENT_POWER_TRACING_DEPRECATED
Message-ID: <20110725195732.GB8302@elte.hu>
References: <alpine.LNX.2.00.1107242313550.7103@swampdragon.chaosbits.net>
 <20110725062743.GB694@elte.hu>
 <alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net>
 <1311618038.3526.28.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311618038.3526.28.camel@gandalf.stny.rr.com>
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

> On Mon, 2011-07-25 at 09:30 +0200, Jesper Juhl wrote:
> > On Mon, 25 Jul 2011, Ingo Molnar wrote:
> > 
> > > 
> > > * Jesper Juhl <jj@chaosbits.net> wrote:
> > > 
> > > > What was scheduled to be 2.6.41 is now going to be 3.1 .
> > > > 
> > > > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > > 
> > > SOB missing.
> > > 
> > 
> > Whoops.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > 
> 
> Ingo, I'm back from vacation. Want me to pull this in. I'll probably
> make a list of things to pull in for 3.1 and some things for 3.2.

Yeah - i've picked this one up already so you can skip it.

Thanks,

	Ingo
