Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1JQTmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:42:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab1JQTl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:41:59 -0400
Date: Mon, 17 Oct 2011 21:40:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.2] tracing: various fixes
Message-ID: <20111017194030.GA6502@elte.hu>
References: <20111017174938.842273454@goodmis.org>
 <20111017185440.GB5545@elte.hu>
 <1318878632.4722.6.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318878632.4722.6.camel@gandalf.stny.rr.com>
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

> On Mon, 2011-10-17 at 20:54 +0200, Ingo Molnar wrote:
> 
> > How about the m32r build fix? I think we should apply it to 
> > perf/core if everyone else was fine with your fix.
> 
> Hmm, I saw a notice that Andrew pulled it into his -mm tree. Is it 
> going that way?

No. It must go into perf/core to not open up a wide bisection 
breakage window. So please apply if it everyone is happy with it.

Thanks,

	Ingo
