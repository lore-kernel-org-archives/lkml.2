Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab0K2TU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:20:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0K2TU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:20:57 -0500
Date: Mon, 29 Nov 2010 20:20:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101129192033.GA18372@elte.hu>
References: <20101121133744.GA10765@elte.hu>
 <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net>
 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
 <20101128201851.GA20555@elte.hu>
 <1291031593.32004.19.camel@laptop>
 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
 <1291052268.32004.171.camel@laptop>
 <1291057565.20709.2.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291057565.20709.2.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> > I know, from the testing so far we _thought_ it was fairly sane. Apparently 
> > there's still some work to do.
> 
> Damn thing bisected to:
> 
> commit 92fd4d4d67b945c0766416284d4ab236b31542c4
> Merge: fe7de49 e53beac
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Nov 18 13:22:14 2010 +0100
> 
>     Merge commit 'v2.6.37-rc2' into sched/core
> 
>     Merge reason: Move to a .37-rc base.
> 
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 92fd4d4d67b945c0766416284d4ab236b31542c4 is the first bad commit

Hm, i'd suggest to double check the two originator points:

  e53beac - is it really 'bad' ?
  fe7de49 - is it really 'good'?

Thanks,

	Ingo
