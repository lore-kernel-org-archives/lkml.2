Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab1C1Evh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 00:51:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1C1Evg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 00:51:36 -0400
Date: Mon, 28 Mar 2011 06:51:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110328045108.GA26322@elte.hu>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110325113048.GC29521@elte.hu>
 <alpine.LFD.2.02.1103260036300.28928@x980>
 <201103272340.42748.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103272340.42748.linux@rainbow-software.org>
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


* Ondrej Zary <linux@rainbow-software.org> wrote:

> > Is there somebody on LKML that has a older laptop than me
> > and is able to get it to boot in APM mode?  I'd be astonished
> > if there was not.  Are they willing to regularly test changes
> > to the upstream kernel to make sure that APM still works?
> > If yes, where have they been for the last 5 years?
> 
> I just tested 2.6.38-rc4 on a desktop board and it works (power off at least). 

Ok, thanks for testing. I too tried APM poweroff in the not too distant past 
and it worked - but not very recent kernels.

Thanks,

	Ingo
