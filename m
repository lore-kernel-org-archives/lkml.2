Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1EDQbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:31:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1EDQbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:31:06 -0400
Date: Wed, 4 May 2011 18:30:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: Fix the lockless code on 32-bit platforms with no
 64-bit cmpxchg
Message-ID: <20110504163046.GA31689@elte.hu>
References: <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos>
 <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos>
 <20110504141413.GA14127@elte.hu>
 <20110504143616.GA19986@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504143616.GA19986@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > Patch below. Ingo, can you test that please ?
> > 
> > Sure - test underway.
> 
> Ok, the patch below is looking really good - the test would have crashed on the 
> bad kernel. I think we can consider the regression fixed:
> 
>   Acked-and-tested-by: Ingo Molnar <mingo@elte.hu>
> 
> I'll keep it running some more to make really sure it's fixed, plus it would 
> be nice if Walter tested your fix as well.

Stopped the test after 2 hours uptime - i think we can consider the crash 
fixed.

Thanks,

	Ingo
