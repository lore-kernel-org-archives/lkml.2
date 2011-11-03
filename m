Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963Ab1KCTrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:47:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46249 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1KCTrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:47:46 -0400
Date: Thu, 3 Nov 2011 20:46:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: REGRESSION: "perf: Add PM notifiers ..." breaks resume
Message-ID: <20111103194601.GA31484@elte.hu>
References: <20111102134900.GB4377@one.firstfloor.org>
 <CA+55aFwCf41GFOVA656-ZgZB5mBNkpH3KqRfJ_Ornkn3RWF5gQ@mail.gmail.com>
 <20111103073725.GA7319@elte.hu>
 <CA+55aFx4sCCyN77v90-a2UW9SQ9FzE-17J-nK9kDBTm0MFsQ3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx4sCCyN77v90-a2UW9SQ9FzE-17J-nK9kDBTm0MFsQ3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Nov 3, 2011 at 12:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Yep, please revert it until we do the right fix. (I can queue up the
> > revert too)
> 
> Reverted,

Thanks!

	Ingo
