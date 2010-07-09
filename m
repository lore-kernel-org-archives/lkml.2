Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0GIH03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:26:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49694 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab0GIH02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:26:28 -0400
Date: Fri, 9 Jul 2010 09:26:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Meelis Roos <mroos@linux.ee>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.35-rc* regression: ERROR: Unable to locate IOAPIC for GSI *
Message-ID: <20100709072619.GE10743@elte.hu>
References: <alpine.SOC.1.00.1007081644200.15817@math.ut.ee>
 <AANLkTinwbPAsCAwrbYVj7_K-YsgKAPyjXlUlQNDZ7eqa@mail.gmail.com>
 <alpine.SOC.1.00.1007090121300.27187@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1007090121300.27187@math.ut.ee>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2959]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Meelis Roos <mroos@linux.ee> wrote:

> > Do you have bootlog for 2.6.34 with "debug apic=debug"?
> 
> Below.
> 
> > Meelis do you have a boot trace from 2.6.34?  Meelis can you confirm
> > that you don't come up in XT_PIC mode in 2.6.34?
> 
> Now that was a good question. It's XT-PIC in 2.6.34 too, just the ERROR: 
> lines are not there.

So it's not really a regression, just a bit noisier bootup?

	Ingo
