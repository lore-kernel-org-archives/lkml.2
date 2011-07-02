Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1GBJIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 05:08:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab1GBJIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 05:08:21 -0400
Date: Sat, 2 Jul 2011 11:08:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [patch 1/1] sched: update_curr versus correct cfs_rq in
 check_preempt_wakeup
Message-ID: <20110702090817.GB17482@elte.hu>
References: <20110702005222.262883892@google.com>
 <20110702005228.481583467@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110702005228.481583467@google.com>
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


* Paul Turner <pjt@google.com> wrote:

> We update_curr() versus the current entity as the preemption 
> decision is based on the relative vruntime.  However, update_curr() 
> is not hierarchical and in the group scheduling case 
> find_matching_se() will have us making the comparison on a cfs_rq 
> different to the one just updated.

Would be nice to include more contextual information in the 
changelog: how did you find it, what effect (if any) did you
see from this patch, what effect do you expect others to see
(if any).

Thanks,

	Ingo
