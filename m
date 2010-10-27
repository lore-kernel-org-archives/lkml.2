Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab0J0PnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:43:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab0J0PnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:43:11 -0400
Date: Wed, 27 Oct 2010 17:43:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
Message-ID: <20101027154302.GA22816@elte.hu>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
 <AANLkTim_3vhuJt2gYQEM5p=wxVU1Jsm6reTgQZsu_o7B@mail.gmail.com>
 <20101027153053.GA20243@elte.hu>
 <20101027153331.GA21789@elte.hu>
 <4CC847D9.3080805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC847D9.3080805@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo, Linus.
> 
> On 10/27/2010 05:33 PM, Ingo Molnar wrote:
> > Btw., the NUMA stuff never really worked percpu alloc, as per Eric's observation:
> 
> Oh, it works in general.  In this case, it's probably because the NUMA 
> configuration is rather weird in 32bit (but then again NUMA on 32bit is supposed 
> to be so).  I think it's just 32bit init code setting up early_cpu_to_node() 
> differently.

Yeah, i meant on x86 32-bit only - which the whole thread is about.

Thanks,

	Ingo
