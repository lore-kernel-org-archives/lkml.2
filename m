Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1DGTbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:31:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45606 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab1DGTbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:31:17 -0400
Date: Thu, 7 Apr 2011 21:31:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        lucas.de.marchi@gmail.com
Subject: Re: [GIT PULL] Fix common misspellings
Message-ID: <20110407193103.GC28209@elte.hu>
References: <20110331032307.GA27999@vigoh>
 <20110331062949.GA29526@elte.hu>
 <20110331144400.GA2618@vigoh>
 <BANLkTin76790Y=6Q8vmq92b_4+7f+hzWZQ@mail.gmail.com>
 <BANLkTikDc0o6Kf5Ym5XkmpeY54fPc67SVw@mail.gmail.com>
 <BANLkTi=SZ_h5OpHpR7oa=+in51UciJA+UA@mail.gmail.com>
 <20110407191928.GA26693@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407191928.GA26693@elte.hu>
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


Ok, i went over the commit with a fine comb again and these were the ones i was 
able to find.

Btw., funniest typo was a typo in a changelog entry, which changelog entry 
itself was about fixing a typo:

	- Tiny (mispelling->misspelling) fixed (ABORT instead of ABRT). Was fortunately

:-)

Thanks,

	Ingo
