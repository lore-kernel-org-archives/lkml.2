Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab0EWKUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 06:20:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab0EWKUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 06:20:32 -0400
Date: Sun, 23 May 2010 12:20:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET sched/core] sched: prepare for cmwq
Message-ID: <20100523102024.GA20869@elte.hu>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
 <4BF1CD92.9030800@kernel.org>
 <4BF689DD.2090306@kernel.org>
 <20100523090544.GB25524@elte.hu>
 <4BF8F0A4.5060608@kernel.org>
 <20100523091306.GE25524@elte.hu>
 <4BF8F46A.1060407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF8F46A.1060407@kernel.org>
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

> Hello,
> 
> On 05/23/2010 11:13 AM, Ingo Molnar wrote:
>
> > ... which is then used for the concurrency-managed 
> > workqueue feature, which is then used for a BTRFS 
> > speedup, right?
> >
> > ( If that's not the plan then color me confused :)
> 
> Yeap, you're officially confused. :-) It doesn't have 
> much to do with btrfs at this point [...]

Not exclusive to btrfs of course, but IIRC one of the 
examples given in one of those threads was btrfs 
scalability, right?

In case it's not obvious, i'm trying to find a tangible 
improvement to examine. No need to resend stuff, do you 
have a link to that old performance measurement by any 
chance?

Thanks,

	Ingo
