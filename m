Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0HTIVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:21:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab0HTIVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:21:15 -0400
Date: Fri, 20 Aug 2010 10:21:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "D. Stussy" <kd6lvw@verizon.net>, linux-tip-commits@vger.kernel.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, luca@luca-barbieri.com,
        tglx@linutronix.de, Greg KH <gregkh@suse.de>
Subject: Re: [tip:x86/urgent] x86, asm: Refactor atomic64_386_32.S to support
 old binutils and be cleaner
Message-ID: <20100820082103.GF17551@elte.hu>
References: <85878.24188.qm@web84204.mail.re3.yahoo.com>
 <4C6DA0C0.6020808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6DA0C0.6020808@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0081]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/19/2010 12:06 PM, D. Stussy wrote:
> > Has this patch been posted to the 2.6.35 kernel also, or just to 2.6.36?  I don't think it's been posted to 2.6.35 where the problem it corrects was introduced.
> > 
> > "Greg KH" <gregkh@suse.de> has made a last call (tomorrow - Aug 20) for chnges for 2.6.35.3 and doesn't seem to have this.  It's not in the prior two updates either.....
> 
> It was Cc: <stable@kernel.org>; it's up to Greg to include it or not.

I think Greg generally includes all upstream commits marked with a -stable tag 
- except if it wont apply cleanly, in which case he mails for a backport.

It of course has to fit in the regular stable release cycle, so the patches 
dont propagate instantaneously.

Thanks,

	Ingo
