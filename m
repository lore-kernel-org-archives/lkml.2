Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab1BCR6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:58:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1BCR6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:58:16 -0500
Date: Thu, 3 Feb 2011 18:57:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
Message-ID: <20110203175721.GB8785@elte.hu>
References: <20110125134748.GA10051@laptop>
 <20110125140948.GA26762@elte.hu>
 <20110125150834.GD27510@htj.dyndns.org>
 <20110203143644.GA4085@ucw.cz>
 <4D4AC996.4070307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4AC996.4070307@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/03/2011 06:36 AM, Pavel Machek wrote:
> > 
> > Could we read the log area, first, verify it contains signature, write
> > it back?
> > 								Pavel
> 
> Yes, but that doesn't guarantee no data corruption caused by handing
> over from one driver to another.

Waiting a few seconds? Is there any sufficiently high number of X where waiting X 
seconds would make it safe to touch the hardware? (i.e. it would guarantee that 
pending commands are flushed, etc.)

Thanks,

	Ingo
