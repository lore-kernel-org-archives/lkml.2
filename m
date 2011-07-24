Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1GXSQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:16:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab1GXSQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:16:01 -0400
Date: Sun, 24 Jul 2011 20:15:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH] x86, olpc: Fix dependency on POWER_SUPPLY
Message-ID: <20110724181512.GA24338@elte.hu>
References: <20110724173321.747BC9D401C@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724173321.747BC9D401C@zog.reactivated.net>
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

> As reported by Randy Dunlap, CONFIG_POWER_SUPPLY=m caused a compile error:
> 
> arch/x86/built-in.o: In function `battery_status_changed':
> olpc-xo15-sci.c:(.text+0x3acdd): undefined reference to `power_supply_get_by_name'
> olpc-xo15-sci.c:(.text+0x3ad04): undefined reference to `power_supply_changed'
> 
> The SCI drivers, as bool, require POWER_SUPPLY to be builtin. Use
> select to make that a hard requirement and avoid this build failure.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Note that we generally try to add a Reported-by tag in such cases. 

(i've added that, no need to resend.)

Thanks,

	Ingo
