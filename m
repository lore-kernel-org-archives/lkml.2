Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1FOHn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:43:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38195 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1FOHnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:43:23 -0400
Date: Wed, 15 Jun 2011 09:43:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6 of 6] x86, UV: correct UV2 BAU destination timeout
Message-ID: <20110615074319.GC3538@elte.hu>
References: <E1QWchi-0004Ng-1i@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QWchi-0004Ng-1i@eag09.americas.sgi.com>
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> Correct the UV2 broacast assist unit's destination timeout period.
>   The period is set in 4 bits of memory-mapped register MISC_CONTROL.
>   The left bit toggles base period between 10us and 80us.
>   The other 3 bits are the multiplier.
> Decimal 15, hex f, gives the maximum: 7 * 80us
> 
> And the activation status register in UV2 should be tested for a destination
> timeout with a 4, not a 2.  The values for Active versus Timeout were reversed.

This changelog tells us everything except what a user of this code 
would be most interested in: what was the practical effect of the 
bug, how badly does the user want the fix?

Thanks,

	Ingo
