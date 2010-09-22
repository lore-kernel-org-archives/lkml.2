Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0IVSIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:08:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39091 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab0IVSIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:08:53 -0400
Date: Wed, 22 Sep 2010 20:08:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf build fixes for opensuse 10.0
Message-ID: <20100922180834.GA8482@elte.hu>
References: <20100922090336.GA5338@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922090336.GA5338@basil.fritz.box>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Fix the perf Makefile to compile on opensuse 10.0
> 
> -Werror in shipping code is usually a bad idea. Remove that. Also 
> remove warning options that are not supported in older compilers. And 
> fix a missing include for __always_inline.

NAK, for obvious reasons.

Please send patches that fix those warnings instead. Yes, some will be 
false positives - but quite a few will point to problems we want to 
address.

Thanks,

	Ingo
