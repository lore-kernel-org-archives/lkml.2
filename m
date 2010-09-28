Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab0I1I1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:27:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab0I1I1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:27:48 -0400
Date: Tue, 28 Sep 2010 10:27:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Pekka Enberg <penberg@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v3] hwmon (coretemp): Fix build breakage if SMP is
 undefined
Message-ID: <20100928082729.GA20898@elte.hu>
References: <1285637552-1058-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285637552-1058-1-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> Commit e40cc4bdfd4b89813f072f72bd9c7055814d3f0f introduced
> a build breakage if CONFIG_SMP is undefined. This commit
> fixes the problem.

This commit works around the problem in a hacky but not-so-ugly way.

( You might also want to include Linus's suggestion about how to fix it 
  for real in the future - so that we have at least some kind of record 
  of it. )

> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>

FYI, while i dont care about my Reported-by's but you lost a Reported-by 
tag here - you should be as careful about them as about your own 
signoffs.

> v2: Fix compile warning due to unused variable i if SMP is undefined 
> v3: include asm/smp.h instead of using ifdef CONFIG_SMP

I've started testing this fix - but i'd expect it to fix the problem - 
so consider it fixed unless i report back within a few hours that 
there's some breakage left.

Thanks,

	Ingo
