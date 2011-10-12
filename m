Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1JLQbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:31:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45597 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1JLQbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:31:24 -0400
Date: Wed, 12 Oct 2011 18:29:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff King <peff@peff.net>
Cc: Valdis.Kletnieks@vt.edu, git@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/20] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111012162947.GC31857@elte.hu>
References: <20111010133852.829771373@goodmis.org>
 <20111011055017.GA32616@elte.hu>
 <20002.1318367320@turing-police.cc.vt.edu>
 <20111012080711.GM18618@elte.hu>
 <20111012141939.GA25085@sigill.intra.peff.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012141939.GA25085@sigill.intra.peff.net>
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


* Jeff King <peff@peff.net> wrote:

> > It's really useful for a painless UI flow to disambiguate failure 
> > messages into clearly actionable variants.
> 
> I agree. I think some people are concerned with leaking information 
> about which repos exist and how they are configured. That is 
> probably not a big problem for a public site like kernel.org, 
> though.

Well, a gitconfig option could be provided to not leak that small 
amount of info - but it would otherwise be weird for an OSS SCM to 
default to a behavior that only makes sense with closed source, 
right? :-)

Thanks,

	Ingo
