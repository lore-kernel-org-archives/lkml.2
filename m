Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab0FJMO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:14:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52198 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183Ab0FJMO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:14:58 -0400
Date: Thu, 10 Jun 2010 14:14:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100610121440.GA20130@elte.hu>
References: <cover.1276116186.git.jbaron@redhat.com>
 <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com>
 <1276171930.2077.200.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276171930.2077.200.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> > +       select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> 
> That deserves a comment somewhere, it basically makes OPTIMIZE_FOR_SIZE 
> useless...

Hm, we need more than a comment for that - distros enable CC_OPTIMIZE_FOR_SIZE 
all the time, for the massive kernel image (and hotpath cache footprint) 
savings. Is this fixable?

Thanks,

	Ingo

