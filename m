Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0EWJFy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:05:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0EWJFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:05:51 -0400
Date: Sun, 23 May 2010 11:05:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] sched: prepare for cmwq
Message-ID: <20100523090544.GB25524@elte.hu>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
 <4BF1CD92.9030800@kernel.org>
 <4BF689DD.2090306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF689DD.2090306@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Peter, Ingo.
> 
> On 05/18/2010 01:13 AM, Tejun Heo wrote:
> > On 05/13/2010 12:48 PM, Tejun Heo wrote:
> >> These four patches are the scheduler modifications necessary for cmwq
> >> and contains the following four patches.
> > 
> > Ping.
> > 
> 
> I know we're inside -rc1 merge window but I'm really 
> hoping to push cmwq through linux-next during this devel 
> cycle as the whole thing basically has been blocked 
> unchanged on scheduler changes for a couple of months 
> now.  So, can we please get this thing moving?

IIRC these changes are for some sort of speedup for btrfs, 
right?

I would really like to see before/after numbers on some 
important FS workload. How much of a speedup does it give?

Thanks,

	Ingo
