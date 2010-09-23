Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab0IWGdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:33:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab0IWGdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:33:16 -0400
Date: Thu, 23 Sep 2010 08:32:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] jump label: add jump label code
Message-ID: <20100923063241.GA17733@elte.hu>
References: <20100923034910.867858597@goodmis.org>
 <1285214792.26872.645.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285214792.26872.645.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0294]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hmm, interesting that the Subject is missing the [PATCH 00/11].
> 
> Ah! doing a test, I see that "quilt mail" will not add that, if you 
> delete the space after "Subject:".  Yes, I develop in git, but send 
> out patches in quilt. That's just the way I am.

The lack of 00/11 doesnt even look bad - the threading of the emails you 
sent was correct and i didnt even notice that the 00/11 is missing. The 
numbering of the rest is what matters, and proper threading.

( The more annoying variants are the recursive-nested Git sends - and
  the totally unthreaded random-lkml-order-of-the-day patch dumps. )

Thanks,

	Ingo
