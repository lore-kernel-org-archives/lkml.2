Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0EWJNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:13:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0EWJNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:13:15 -0400
Date: Sun, 23 May 2010 11:13:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] sched: prepare for cmwq
Message-ID: <20100523091306.GE25524@elte.hu>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
 <4BF1CD92.9030800@kernel.org>
 <4BF689DD.2090306@kernel.org>
 <20100523090544.GB25524@elte.hu>
 <4BF8F0A4.5060608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF8F0A4.5060608@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> On 05/23/2010 11:05 AM, Ingo Molnar wrote:
> > IIRC these changes are for some sort of speedup for btrfs, 
> > right?
> 
> Eh.... What are you talking about?  These are for cmwq.  
> The "must unify scheduler notification hooks", "nah, if 
> always enabled, go with hard coded hooks" stuff.

... which is then used for the concurrency-managed 
workqueue feature, which is then used for a BTRFS speedup, 
right?

( If that's not the plan then color me confused :)

Thanks,

	Ingo
