Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1FHIUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:20:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1FHIUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:20:09 -0400
Date: Wed, 8 Jun 2011 10:19:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: Readd asmregparm
Message-ID: <20110608081957.GA14966@elte.hu>
References: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> For a followon patchkit of mine I need to mark all functions
> that can be called from assembler. But on 32bit kernels some
> assembler functions are called with register arguments and others
> with stack arguments. asmlinkage forces stack arguments.
> 
> This patch readds the recently removed asmregparm to be able
> to mark assembler functions called with register arguments on 32bit.
> 
> Unlike the old code it's x86 only now to prevent it from
> leaking.
> 
> Cc: x86@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

That's a totally useless changelog (you are deliberately hiding 
information again) so the series is obviously not acceptable.
Please fix and resend.

Thanks,

	Ingo
