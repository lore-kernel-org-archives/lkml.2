Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0DSVBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:01:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0DSVBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:01:52 -0400
Date: Mon, 19 Apr 2010 23:01:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, tilman@imap.cc, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree build failure, [patch] fix isdn/gigaset build
 failure
Message-ID: <20100419210142.GA21440@elte.hu>
References: <20100419180520.GA9244@elte.hu>
 <alpine.LFD.2.00.1004191112550.14500@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004191200050.14500@i5.linux-foundation.org>
 <20100419.120600.82034948.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419.120600.82034948.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 19 Apr 2010 12:00:49 -0700 (PDT)
> 
> > On Mon, 19 Apr 2010, Linus Torvalds wrote:
> >> 
> >> Maybe add the #include <linux/sched.h> into gigaset.h, instead of 
> >> common.c?
> > 
> > This compiled for me, although the only thing I tried was just turning all 
> > the gigaset options to 'y'. Maybe some other config doesn't work. So I 
> > committed it as likely to fix things.
> 
> Thanks Linus.
> 
> Ingo, let us know if there is still some problems in your
> build tests.

I did a few tests and it looks good here!

Thanks,

	Ingo
