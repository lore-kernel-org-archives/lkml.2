Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0KRJhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:37:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36776 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab0KRJhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:37:09 -0500
Date: Thu, 18 Nov 2010 10:36:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Jean Pihet <jean.pihet@newoldbits.com>, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
Message-ID: <20101118093656.GD28467@elte.hu>
References: <1289498595-25806-1-git-send-email-trenn@suse.de>
 <201011140734.07770.trenn@suse.de>
 <20101118080132.GH32621@elte.hu>
 <201011181027.09363.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011181027.09363.trenn@suse.de>
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


* Thomas Renninger <trenn@suse.de> wrote:

> On Thursday 18 November 2010 09:01:32 Ingo Molnar wrote:
> ...
> > > @Ingo: If this does not go into x86/tip, but perf or whatever tree, it would
> > > be great if you can ping me as soon as this stuff is in.
> > 
> > Mind sending the latest version which has been adjusted/fixed and all acks added?
> Done.
> This time with lkml excluded as there were only cleanups/fixes
> due to a messed merge.

Please do not exclude lkml from such iterations of patches in the future - every 
modification to patches is relevant - often pure resends get resent to lkml as well.

Thanks,

	Ingo
