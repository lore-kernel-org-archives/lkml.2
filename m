Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1E3JPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:15:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab1E3JPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:15:43 -0400
Date: Mon, 30 May 2011 11:15:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530091536.GA2827@elte.hu>
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306745835.2029.389.camel@i7.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2011-05-30 at 09:23 +0200, Ingo Molnar wrote:
> > You thoroughly misunderstood my prior regression report, the problem 
> > with your patch was that your patch actually *broke* existing 
> > filtered-randconfig behavior, for example trying to get a 64-bit 
> > randconfig:
> > 
> >   make ARCH=x86_64 randconfig
> > 
> > ... will today produce a 64-bit randconfig while with your old change 
> > applied it produced a 32-bit randconfig 50% of the time.
> 
> I believe that this 'filtered randconfig' behaviour is now fairly much
> the *only* use for the old 'ARCH=i386' and 'ARCH=x86_64'.

I use "make ARCH=i386 defconfig" and "make ARCH=x86_64 defconfig" all 
the time.

Thanks,

	Ingo
