Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1JRTs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:48:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:33792 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1JRTs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:48:57 -0400
Date: Tue, 18 Oct 2011 21:48:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Simon Kirby <sim@hostway.ca>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
Subject: Re: Linux 3.1-rc9
In-Reply-To: <20111018182046.GF1309@hostway.ca>
Message-ID: <alpine.LFD.2.02.1110182146440.3240@ionos>
References: <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <1318847658.6594.40.camel@twins> <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com> <1318874090.4172.84.camel@twins>
 <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com> <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos> <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins> <20111018182046.GF1309@hostway.ca>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Simon Kirby wrote:
> Looks good running on three boxes since this morning (unpatched kernel
> hangs in ~15 minutes).
> 
> While I have your eyes, does this hang trace make any sense (which
> happened a couple of times with your previous patch applied)?
> 
> http://0x.ca/sim/ref/3.1-rc9/3.1-rc9-tcp-lockup.log
> 
> I don't see how all CPUs could be spinning on the same lock without
> reentry, and I don't see the any in the backtraces.

Weird.

Which version of Peters patches was this, the extra lock or the
atomic64 thingy?

It does not look related. Could you try to reproduce that problem with
lockdep enabled? lockdep might make it go away, but it's definitely
worth a try.

Thanks,

	tglx
