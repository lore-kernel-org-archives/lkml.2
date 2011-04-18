Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1DRUhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:37:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1DRUhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:37:41 -0400
Date: Mon, 18 Apr 2011 22:37:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
Message-ID: <20110418203726.GA30868@elte.hu>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
 <BANLkTi=hpNy3iA+49N90dbU4f0_L2RVJNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=hpNy3iA+49N90dbU4f0_L2RVJNQ@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Some opteron love would be good, but I don't have access to any right here.

Here's one:

 CPU vendor   : AuthenticAMD
 CPU model    : Quad-Core AMD Opteron(tm) Processor 8356
 CPU stepping : 3
 TSC flags    : tsc rdtscp constant_tsc nonstop_tsc
 Using mfence_rdtsc because you don't have an Intel CPU
 Will test the "mfence;rdtsc" clock.
 Now test passed  : margin 252 with 7198256 samples
 Load3 test passed: margin 536 with 1833844 samples
 Load test passed : margin 219 with 3097882 samples
 Store test passed: margin 250 with 3553454 samples

Thanks,

	Ingo
