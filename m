Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0JWPw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:52:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58359 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab0JWPwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:52:25 -0400
Date: Sat, 23 Oct 2010 17:52:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree boot failure] Re: [GIT PULL] core block bits for
 2.6.37-rc1
Message-ID: <20101023155214.GA24353@elte.hu>
References: <4CC143F5.3060202@fusionio.com>
 <20101023152959.GA20930@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023152959.GA20930@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> [  116.080274]  [<ffffffff8165dc53>] blk_cleanup_queue+0x63/0x68
> [  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
> [  116.080274]  [<ffffffff84883f54>] hd_init+0x2d4/0x302
> [  116.080274]  [<ffffffff81910778>] ? device_pm_unlock+0x15/0x17
> [  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
> [  116.080274]  [<ffffffff81002062>] do_one_initcall+0x57/0x15a
> [  116.080274]  [<ffffffff8482f78b>] kernel_init+0x194/0x222

Btw., another data point, the crash goes away when the ancient XT-HD driver is 
turned off:

 # CONFIG_BLK_DEV_HD is not set

I'm not sure whether the bug is limited to this driver alone though.

	Ingo
