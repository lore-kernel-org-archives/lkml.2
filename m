Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab1EPMXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:23:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab1EPMXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:23:37 -0400
Date: Mon, 16 May 2011 14:23:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516122329.GA29356@elte.hu>
References: <20110513084253.GE13647@elte.hu>
 <20110513121906.GA3676@elte.hu>
 <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516115148.GA2421@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > In the meantime, would you be willing to try out the patch at 
> > https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
> > several configurations.
> 
> Wasn't this the one i tested - or is it a new iteration?
> 
> I'll try it in any case.

oh, this was a new iteration, mea culpa!

And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)

Thanks,

	Ingo
