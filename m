Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0DHIWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:22:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41992 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab0DHIWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:22:38 -0400
Date: Thu, 8 Apr 2010 10:22:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100408082221.GA14983@elte.hu>
References: <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
 <20100331185916.GA12306@elte.hu>
 <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
 <4BB3DC4E.7030504@zytor.com>
 <alpine.LRH.2.00.1004011042460.32618@tundra.namei.org>
 <4BB3DF46.8080008@zytor.com>
 <alpine.LRH.2.00.1004011200020.365@tundra.namei.org>
 <20100401125210.GA2445@elte.hu>
 <20100408063236.GA23489@elte.hu>
 <alpine.LRH.2.00.1004081805170.25632@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1004081805170.25632@tundra.namei.org>
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


* James Morris <jmorris@namei.org> wrote:

> On Thu, 8 Apr 2010, Ingo Molnar wrote:
> 
> > ping? Can you or Dave reproduce the bug with -rc3 or later kernels? (If not 
> > then it probably means that the bug you triggered was already fixed at the 
> > time you reported it, as hpa suspected.)
> 
> I haven't seen it since.

Great, thanks!

	Ingo
