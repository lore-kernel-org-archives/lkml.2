Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2ACIIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:08:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60733 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2ACII3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:08:29 -0500
Date: Tue, 3 Jan 2012 09:06:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20120103080618.GA10149@elte.hu>
References: <20120103160813.d2a8575c1de3bad0acd42280@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103160813.d2a8575c1de3bad0acd42280@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in kernel/futex.c
> between commit e6780f7243ed ("futex: Fix uninterruptible loop due to
> gate_area") from the  tree and commit ab69f41ef93d ("futex: Fix
> uninterruptible loop due to gate_area") from the tip tree.
> 
> OK, so these appear to be 2 different versions of the same 
> fix.  I cannot figure out which to use, so I just used the 
> version from the tip tree ...

No, Linus's version is the correct resolution - i've resolved 
this in tip:auto-latest.

Thanks,

	Ingo
