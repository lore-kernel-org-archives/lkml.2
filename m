Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab1CWPlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:41:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab1CWPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:41:51 -0400
Date: Wed, 23 Mar 2011 16:41:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: wu junhui <wjh.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: sched: new cpu schedule
Message-ID: <20110323154144.GA20152@elte.hu>
References: <AANLkTinWrchYyqF8qAGGQAt9JCbAj46txqK-MD2TEZe1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinWrchYyqF8qAGGQAt9JCbAj46txqK-MD2TEZe1@mail.gmail.com>
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


* wu junhui <wjh.kernel@gmail.com> wrote:

> hello
> 
> i have a new cpu schedule, i name it NanJing for my city.
> 
> it's O(1),
> it's one queue,
> it's load balance o(1),
> it's fair,
> it's i/o friendly,
> 
> todo:
> powersave,
> human interface (keyboard, mouse event) promotion,
> optimalize clean,
> 
> 
> my developing  platform is centos 5.5
> 
> rpmbuild -bp 2.6.18-194.32.1.el5 source
> 
> .config use /boot/config
> 
> i had do some test, it's work. in diff i have some explain. if
> somebody interest, i can explain more later.
> 
> sorry for the last post with attatch patch.
> 
> thanks.
> 
> Wu JunHui
> 
> --- linux-2.6.18.i686_org/kernel/sched.c	2011-03-07 14:12:46.000000000 +0800
> +++ linux-2.6.18.i686/kernel/sched.c	2011-03-23 10:02:06.000000000 +0800

2.6.18 is an almost 5 years old kernel so your patch will not apply to any 
recent kernel:

Hunk #1 FAILED at 16.
Hunk #2 succeeded at 100 with fuzz 1 (offset 25 lines).
Hunk #3 FAILED at 93.
Hunk #4 FAILED at 196.
Hunk #5 FAILED at 229.
Hunk #6 FAILED at 727.
Hunk #7 succeeded at 2041 (offset 1236 lines).
Hunk #8 succeeded at 2058 (offset 1236 lines).
Hunk #9 FAILED at 843.
Hunk #10 FAILED at 861.
Hunk #11 FAILED at 951.
Hunk #12 FAILED at 1049.
Hunk #13 succeeded at 2178 with fuzz 2 (offset 1121 lines).

etc.

Scheduler developers use the latest scheduler development tree, which can be 
found at:

   http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
