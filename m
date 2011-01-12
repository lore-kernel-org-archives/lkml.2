Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1ALI2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:28:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab1ALI2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:28:33 -0500
Date: Wed, 12 Jan 2011 09:28:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
Message-ID: <20110112082820.GC9868@elte.hu>
References: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
 <4d2654c410489a1b90@agluck-desktop.sc.intel.com>
 <AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com>
 <AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
 <AANLkTim6Qn5Ttc9w673c1jrT0dObm8x_Osvbf9Vhjfys@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim6Qn5Ttc9w673c1jrT0dObm8x_Osvbf9Vhjfys@mail.gmail.com>
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


* Tony Luck <tony.luck@intel.com> wrote:

> On Thu, Jan 6, 2011 at 4:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > Assume Tony will have another patch for IA64 to check that before
> > apply this patch.
> 
> Ingo,
> 
> Ok, I sent (a slightly modified version of) this patch up to Linus
> as part of the ia64 merge window pull ... so it is safe to update
> drivers/acpi/numa.c with a patch that will parse all the SRAT cpu
> entries down to ia64 now.

Thanks Tony!

Since the original commit d3bd058 is already upstream i suspect we should be fine 
all around, right?

	Ingo
