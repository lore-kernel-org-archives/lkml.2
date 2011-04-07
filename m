Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1DGSvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:51:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab1DGSu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:50:59 -0400
Date: Thu, 7 Apr 2011 20:50:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        lucas.de.marchi@gmail.com
Subject: Re: [GIT PULL] Fix common misspellings
Message-ID: <20110407185043.GA11496@elte.hu>
References: <20110331032307.GA27999@vigoh>
 <20110331062949.GA29526@elte.hu>
 <20110331144400.GA2618@vigoh>
 <BANLkTin76790Y=6Q8vmq92b_4+7f+hzWZQ@mail.gmail.com>
 <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Regardless, those were the only ones I _noticed_, there may well be
> others. I'd suggest people try to find more. The easiest way I found
> to go through it was:
> 
>    git show -U0 --color-words 25985edcedea
> 
> which makes it reasonably dense and easy to see.

Wow, -U0 --color-words really rocks as a review tool ...

Some other mistakes:

+	.usecount = 1,              /* REVISIT: why can't' this be disabled? */
+	.usecount = 1,              /* REVISIT: why can't' this be disabled? */
+	 * isn't' set.
+	 * isn't' set.
+	 * isn't' set.
+	/* We can't' use dev_ready here, but at least we wait for the
+		dev_dbg(&p_dev->dev, "Configuration isn't't locked\n");
+	/* Drop not U2M frames, can't's drop here because we will drop beacon in this case */
+	/* Drop not U2M frames, can't's drop here because we will drop beacon in this case */

Thanks,

	Ingo
