Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab1EZTNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:13:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab1EZTND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:13:03 -0400
Date: Thu, 26 May 2011 21:12:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, greearb@candelatech.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de, netdev@vger.kernel.org
Subject: Re: [patch] net/core/filter.c: Fix build error
Message-ID: <20110526191256.GA4553@elte.hu>
References: <efa062542c692c3f7743bf2d97b5987ab989e27e.1305999731.git.joe@perches.com>
 <20110526123153.GA16002@elte.hu>
 <1306423866.16087.10.camel@Joe-Laptop>
 <20110526.143843.205897228685761536.davem@davemloft.net>
 <20110526190939.GC3476@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526190939.GC3476@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> So no, i don't think your patch is the real solution. [...]

s/real/complete

Note, your patch solves a real problem: the ratelimited WARN_ON()s 
should not be in the generic bug.h header, that's just broken.

I just don't think this is the only problem: the other problem was 
what hid the bug in the first place, the spurious ratelimit.h 
inclusion via net.h.

Thanks,

	Ingo
