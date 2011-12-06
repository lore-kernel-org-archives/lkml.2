Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1LFSWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:22:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1LFSWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:22:15 -0500
Date: Tue, 6 Dec 2011 19:20:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206182035.GA12094@elte.hu>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <20111206175443.GB25031@elte.hu>
 <20111206181422.GA11881@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206181422.GA11881@elliptictech.com>
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


* Nick Bowler <nbowler@elliptictech.com> wrote:

> > Your original patch did two things. Peter did the sensible 
> > thing: he split out the print_kernel_ident() changes from 
> > your patch which stand on their own and kept your authorship 
> > in place - that is what the above patch does.
> 
> In which case, the changelog should have been amended to state 
> that it's a modification of Ben's original submission.

Which is what i said in my reply to Alan:

 | What Peter probably could have done is to add one more line
 | before his SOB:
 |
 |   [ split out the patch from the original submission ]
 |   Signed-off-by: Peter Zijlstra <peterz@infradead.org>
 |
 | Otherwise Ben Hutchings's objection here makes little sense.

No line of code was added by Peter - it's all Ben's changes.

Note that the commit in question:

  fbdc4b9a6c29: lockdep, rtmutex, bug: Show taint flags on error

is actually a good one and i think even Ben actually thinks 
those changes are good. Nothing was added - Ben only wants 
*more* to be done in a single patch and is being silly about the 
SOB and is asking it to be removed.

Thanks,

	Ingo
