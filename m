Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab1GXSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:25:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37437 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1GXSZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:25:25 -0400
Date: Sun, 24 Jul 2011 20:24:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH] x86, olpc: Fix dependency on POWER_SUPPLY
Message-ID: <20110724182437.GA29660@elte.hu>
References: <20110724173321.747BC9D401C@zog.reactivated.net>
 <20110724181512.GA24338@elte.hu>
 <CAGq3pz52P3oaXaERB5D+3g1egbBeT7OO_HuoYy66MQWWr00EnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGq3pz52P3oaXaERB5D+3g1egbBeT7OO_HuoYy66MQWWr00EnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Daniel Drake <dsd@laptop.org> wrote:

> On 24 July 2011 19:15, Ingo Molnar <mingo@elte.hu> wrote:
> > Note that we generally try to add a Reported-by tag in such cases.
> >
> > (i've added that, no need to resend.)
> 
> I'll remember that for next time.
> 
> Please let me know if theres anything else I can do to help the 
> process of getting these patches into mainline.

Not at the moment - i've merged them and testing them now to see 
whether the boot crash is gone. Will let you know if there's any
test failure.

Thanks,

	Ingo
