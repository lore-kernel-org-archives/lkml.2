Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab0KID2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:28:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53434 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0KID2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:28:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20101109105801.BC30.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.2.00.1011011232120.6822@chino.kir.corp.google.com> <20101109105801.BC30.A69D9226@jp.fujitsu.com>
Message-Id: <20101109122817.BC5A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 12:28:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, I've tested it, and it deprecates the tunable as expected.  A single 
> > warning message serves the purpose well: let users know one time without 
> > being overly verbose that the tunable is deprecated and give them 
> > sufficient time (2 years) to start using the new tunable.  That's how 
> > deprecation is done.
> 
> no sense.
> 
> Why do their application need to rewrite for *YOU*? Okey, you will got
> benefit from your new knob. But NOBDOY use the new one. and People need
> to rewrite their application even though no benefit. 
> 
> Don't do selfish userland breakage!

And you said you ignore bug even though you have seen it. It suck!



