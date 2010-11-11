Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0KKSGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:06:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45429 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab0KKSGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:06:44 -0500
Date: Thu, 11 Nov 2010 19:06:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Dongdong Deng <dongdong.deng@windriver.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V3 PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace()
 at the same time on SMP
Message-ID: <20101111180630.GB27803@elte.hu>
References: <1289473307-7965-1-git-send-email-dongdong.deng@windriver.com>
 <20101111111702.GA12644@elte.hu>
 <20101111143425.GG4823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111143425.GG4823@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> On Thu, Nov 11, 2010 at 12:17:02PM +0100, Ingo Molnar wrote:
> > 
> > Hm, another thing i noticed is that there's two of these:
> 
> I guess it depends how we want to deprecate the old nmi watchdog.

ah, indeed, i forgot about the old watchdog.

Lets zap it right now and see who complains? Mind sending a patch for that? (please 
also pick up Dongdong's patch)

Thanks,

	Ingo
