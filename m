Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0JYGgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 02:36:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47238 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab0JYGgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 02:36:22 -0400
Date: Mon, 25 Oct 2010 08:36:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>
Subject: Re: linux-next: build warning in Linus'  tree
Message-ID: <20101025063605.GA4040@elte.hu>
References: <20101025115736.41d51abe.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025115736.41d51abe.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> In building Linus' tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> arch/x86/oprofile/op_model_amd.c: In function 'ibs_eilvt_valid':
> arch/x86/oprofile/op_model_amd.c:289: warning: 'offset' may be used uninitialized in this function
> 
> .. and indeed it may be.

Yep, that looks bogus. I've queued up the fix.

Thanks,

	Ingo
