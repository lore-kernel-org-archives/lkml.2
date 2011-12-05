Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1LESmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:42:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1LESmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:42:46 -0500
Date: Mon, 5 Dec 2011 19:41:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux-next: Tree for Sept 28 (mrst)
Message-ID: <20111205184105.GA20121@elte.hu>
References: <20110928200404.6ed0d6c34161d233be8994fd@canb.auug.org.au>
 <4E839B94.9040305@xenotime.net>
 <4EDD0FED.7060301@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD0FED.7060301@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 09/28/2011 03:11 PM, Randy Dunlap wrote:
> > On 09/28/11 03:04, Stephen Rothwell wrote:
> >> Hi all,
> > 
> > 
> > When CONFIG_X86_INTEL_MID=y but CONFIG_X86_MRST is not enabled
> > (this is on an i386/X86_32 build):
> > 
> > rtc.c:(.init.text+0x6234): undefined reference to `__mrst_cpu_chip'
> > 
> > Full randconfig file is attached.
> 
> Hm, it's now 20111205 and this build error is still around.
> Is there any hope for getting it fixed?

Alan?

Thanks,

	Ingo
