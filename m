Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0JEGco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:32:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0JEGcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:32:43 -0400
Date: Tue, 5 Oct 2010 08:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
Message-ID: <20101005063227.GB12267@elte.hu>
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au>
 <4CAABC0E.3030700@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAABC0E.3030700@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0299]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> > I think I fixed it all up (see below).  I can carry this fix (or a 
> > better one) as necessary.
> 
> Can you please drop lost-spurious-irq for now?  It needs to be 
> reimplemented.  I'll send a merge request again when it's ready.

Please send irq merge requests to Thomas instead and wait for those 
genirq bits to show up upstream. (You did so in the past and the review 
process was ongoing AFAICS)

Otherwise we would be dilluting linux-next testing with random side 
effects from a tree that wasnt yet (in that form) scheduled to go 
upstream by its respective maintainer at that time.

We were lucky that this showed up as merge complications - what if 
instead it merged 'fine' on the textual and build/boot level but 
mis-merged on the functional level in subtle ways? Thomas would be 
sending something to Linus that was never really tested in linux-next in 
that form, caused problems upstream, and Linus would be rightfully upset 
about the situation.

Stephen, you need to enforce such things ...

Thanks,

	Ingo
