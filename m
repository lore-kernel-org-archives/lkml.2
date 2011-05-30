Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab1E3OpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:45:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57653 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab1E3OoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:44:21 -0400
Date: Mon, 30 May 2011 16:44:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.40
Message-ID: <20110530144409.GB13966@elte.hu>
References: <20110526133948.GX20052@erda.amd.com>
 <20110527122301.GA32754@elte.hu>
 <20110530100039.GB20052@erda.amd.com>
 <20110530100956.GA17821@elte.hu>
 <20110530101619.GC20052@erda.amd.com>
 <20110530144157.GL20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530144157.GL20052@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 30.05.11 12:16:19, Robert Richter wrote:
> > On 30.05.11 06:09:56, Ingo Molnar wrote:
> > > The way IBS is set up is not very obvious and atypical of existing 
> > > preempt_*() patters. Might be worth adding a comment to the 
> > > preempt_disable(), to unconfuse unsuspecting readers who are 
> > > wondering about its oddness?
> > 
> > Yes, will add some comments.
> 
> Ingo,
> 
> please see below and apply the patch to tip, if it makes sense to you.

Yeah, looks good to me - feel free to handle this via the regular 
oprofile flow of patches.

Thanks,

	Ingo
