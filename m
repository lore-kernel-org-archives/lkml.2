Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0HDJZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:25:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab0HDJZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:25:46 -0400
Date: Wed, 4 Aug 2010 11:25:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: bifferos <bifferos@yahoo.co.uk>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what
 c_ident is
Message-ID: <20100804092531.GB2395@elte.hu>
References: <20100803192557.GA13595@elte.hu>
 <646233.80914.qm@web27008.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <646233.80914.qm@web27008.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2442]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* bifferos <bifferos@yahoo.co.uk> wrote:

> I couldn't reproduce this with 2.6.35 (without Peter's change),
> I was trying on VirtualBox.  If the detection code is causing a 
> problem we can just skip it if the CPU has cpuid.

As i reported:

> > -tip testing found that these RDC patches cause a boot
> > crash if a X86_RDC321X=y kernel is booted on a regular PC:

Those two patches caused the crash, with the config i sent, on a regular PC.

	Ingo
