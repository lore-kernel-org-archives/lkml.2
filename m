Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0CVThf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:37:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0CVThd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:37:33 -0400
Date: Mon, 22 Mar 2010 20:37:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       benh@kernel.crashing.org, hpa@zytor.com, jbarnes@virtuousgeek.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
Message-ID: <20100322193720.GA2844@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
 <20100322092809.GA20607@elte.hu>
 <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003221752510.3147@localhost.localdomain>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Ingo,
> 
> On Mon, 22 Mar 2010, Ingo Molnar wrote:
> > 
> > ( Cc:-ed Andrew and Linus as this is a general design/policy matter wrt. 
> >   memory management. )
> > 
> > * David Miller <davem@davemloft.net> wrote:
> > 
> > > From: Yinghai Lu <yinghai@kernel.org>
> > > Date: Sun, 21 Mar 2010 21:28:38 -0700
> > > 
> > > >> 
> > > >> That action means you absolutely don't value our feedback at all.
> > > > 
> > > > [PATCH 01/20] x86: add find_e820_area_node
> > > > is addressing your concern that early_res didn't handle memory cross the nodes problem.
> > > 
> > > Now I know that you _REALLY_ aren't listening to us.
> 
> > [ He has done a bit more than just to simply listen: he seems to
> > have written a patch which he thinks is addressing the concerns you
> > pointed out. It might not be the response you wished for (and it
> > might be inadequate) for but it sure gives me the impression of him
> > listening to you - unless by 'listening' you mean 'follow my exact
> > opinion without argument'. ]
> 
> I tend to disagree. Fixing the bug pointed out by Dave is not really a
> good argument about listening.
> 
> The main point is that there is still no answer why lmb cannot be used and 
> the reposted patch still is a full move of the x86 e820 functions into 
> kernel/fw_memmap.c.
> 
> That's not a generalization, that's simply a relocation of x86 code to 
> kernel/. And I agree with Dave and Ben that this is an useless exercise.

ok - i think you are right. Yinghai, mind having a look at using lib/lmb.c for 
all this?

	Ingo
