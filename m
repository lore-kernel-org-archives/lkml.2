Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1JLIIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:08:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab1JLIIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:08:53 -0400
Date: Wed, 12 Oct 2011 10:07:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu, git@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/20] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111012080711.GM18618@elte.hu>
References: <20111010133852.829771373@goodmis.org>
 <20111011055017.GA32616@elte.hu>
 <20002.1318367320@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20002.1318367320@turing-police.cc.vt.edu>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Tue, 11 Oct 2011 07:50:17 +0200, Ingo Molnar said:
> 
> >  $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/perf/core
> >  fatal: The remote end hung up unexpectedly
> 
> Is it possible to get 'git' to say something more informative than 
> "hung up unexpectedly"? "Tree not found, check URL" or similar 
> would be nice...

I've Cc:-ed the Git development list which has lots of very 
responsive gents on it eager to improve Git.

I see this message dozens of times per year and i am always confused 
about the message.

Firstly, arguably, typoing something is not 'fatal' really - it's 
just a resource that was not found on the server.

Secondly, and more importantly, the reason for the failed pull is 
indeed important to know, if you want to resolve the problem with a 
minimum fuss:

 - Was it the tree that didnt exist?
 - Or the branch?
 - Or was there some other problem [such as a truly unexpectedly 
                                    closed transport socket]?

It's really useful for a painless UI flow to disambiguate failure 
messages into clearly actionable variants.

Thanks,

	Ingo
