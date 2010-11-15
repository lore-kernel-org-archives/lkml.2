Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0KOAYZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:24:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33571 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0KOAYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:24:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20101109122817.BC5A.A69D9226@jp.fujitsu.com>
References: <20101109105801.BC30.A69D9226@jp.fujitsu.com> <20101109122817.BC5A.A69D9226@jp.fujitsu.com>
Message-Id: <20101115092238.BEEE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 09:24:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Yes, I've tested it, and it deprecates the tunable as expected.  A single 
> > > warning message serves the purpose well: let users know one time without 
> > > being overly verbose that the tunable is deprecated and give them 
> > > sufficient time (2 years) to start using the new tunable.  That's how 
> > > deprecation is done.
> > 
> > no sense.
> > 
> > Why do their application need to rewrite for *YOU*? Okey, you will got
> > benefit from your new knob. But NOBDOY use the new one. and People need
> > to rewrite their application even though no benefit. 
> > 
> > Don't do selfish userland breakage!
> 
> And you said you ignore bug even though you have seen it. It suck!


At v2.6.36-rc1, oom-killer doesn't work at all because YOU BROKE.
And I was working on fixing it.

2010-08-19
http://marc.info/?t=128223176900001&r=1&w=2
http://marc.info/?t=128221532700003&r=1&w=2
http://marc.info/?t=128221532500008&r=1&w=2

However, You submitted new crap before the fixing. 

2010-08-15
http://marc.info/?t=128184669600001&r=1&w=2

If you tested mainline a bit, you could find the problem quickly.
You should have fixed mainline kernel at first.


	Again, YOU HAVEN'T TESTED YOUR OWN PATCH AT ALL.





