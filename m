Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0DSTyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:54:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34084 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab0DSTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:54:16 -0400
Date: Mon, 19 Apr 2010 21:54:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, tilman@imap.cc,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree build failure, [patch] fix isdn/gigaset build
 failure
Message-ID: <20100419195405.GA21803@elte.hu>
References: <20100419.003857.260094283.davem@davemloft.net>
 <20100419172731.GA4358@elte.hu>
 <20100419.103304.35342954.davem@davemloft.net>
 <20100419180520.GA9244@elte.hu>
 <alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004191200050.14500@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004191200050.14500@i5.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 19 Apr 2010, Linus Torvalds wrote:
> > 
> > Maybe add the #include <linux/sched.h> into gigaset.h, instead of 
> > common.c?
> 
> This compiled for me, although the only thing I tried was just turning all 
> the gigaset options to 'y'. Maybe some other config doesn't work. So I 
> committed it as likely to fix things.

I'll check it tomorrow - but i'd expect it to be enough, plus the all-yes 
thing is that matters most in practice in any case.

Thanks,

	Ingo
