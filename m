Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2AGM1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 07:27:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2AGM1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 07:27:17 -0500
Date: Sat, 7 Jan 2012 13:25:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
Message-ID: <20120107122511.GB28462@elte.hu>
References: <20120101180949.GA25066@elte.hu>
 <20120102105856.GA6661@elte.hu>
 <20120102134856.GA32673@elte.hu>
 <1325635373.12696.4.camel@gandalf.stny.rr.com>
 <1325635922.12696.8.camel@gandalf.stny.rr.com>
 <1325653301.12696.20.camel@gandalf.stny.rr.com>
 <20120104141107.GA24770@elte.hu>
 <1325696759.12696.24.camel@gandalf.stny.rr.com>
 <20120105091916.GA22598@elte.hu>
 <1325764011.12696.38.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1325764011.12696.38.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > I'm also seeing build failures with certain configs:
> > 
> > kernel/trace/trace_stack.c:387:3: error: implicit declaration of function ‘ftrace_set_early_filter’ 
> > [-Werror=implicit-function-declaration]
> 
> Hmm, your right. It depends on dyn_ftrace to be configured. 
> Strange that my tests didn't catch that as I thought one of my 
> tests compiles with static ftrace. I'll have to look into why 
> my test didn't catch that. I'll send a fix later today.

Hm, i cannot re-test this tree with general randconfig until it 
keeps failing the build. I'll test the NMI bits, to be able to 
exclude those.

Thanks,

	Ingo
