Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1EUO26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:28:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1EUO24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:28:56 -0400
Date: Sat, 21 May 2011 16:28:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl
Subject: Re: [GIT PULL rcu/next] fixes and breakup of memory-barrier-decrease
 patch
Message-ID: <20110521142844.GA29813@elte.hu>
References: <20110521140613.GA13062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521140613.GA13062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This pull requests covers some RCU bug fixes and one patch rework.
> 
> The first group breaks up the infamous now-reverted (but ultimately
> vindicated) "Decrease memory-barrier usage based on semi-formal proof"
> commit into five commits.  These five commits immediately follow the
> revert, and the diff across all six of these commits is empty, so that
> the effect of the five commits is to revert the revert.

But ... the regression that was observed with that commit needs to be fixed 
first, or not? In what way was the barrier commit vindicated?

Thanks,

	Ingo
