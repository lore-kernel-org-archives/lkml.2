Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1BUVNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:13:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53331 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab1BUVNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:13:02 -0500
Date: Mon, 21 Feb 2011 22:12:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
Message-ID: <20110221211227.GA6030@elte.hu>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
 <1298207379.7998.11.camel@marge.simson.net>
 <20110220141003.GA6006@zhy>
 <1298222533.7881.15.camel@marge.simson.net>
 <1298306175.24121.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298306175.24121.14.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2011-02-20 at 18:22 +0100, Mike Galbraith wrote:
> > 
> > Your whole series looked fine to me at a glance (sunday;), with the
> > exception of #2, that one is maybe iffy, depending on point of view.
> 
> Right, so I've queued 1 and 3, 2 is like you said iffy, if there's an
> autogroup it should display it.
> 
> As to 5, I really don't care, Linus did seem to care initially, don't
> know how he feels about it now.

I've Cc:-ed him.

Since Yong Zhang has noticed the difference and has written and tested the patch we 
should consider it i think, it's a QoI improvement. The knob is root-only, right?

Thanks,

	Ingo
