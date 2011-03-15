Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab1COEGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:06:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37699
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab1COEGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:06:35 -0400
Date: Mon, 14 Mar 2011 21:07:12 -0700 (PDT)
Message-Id: <20110314.210712.226761233.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: tglx@linutronix.de, bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, hpa@zytor.com, peterz@infradead.org
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110315113049.a6112494.sfr@canb.auug.org.au>
References: <20110314170546.af552b4e.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.1103141053020.2787@localhost6.localdomain6>
	<20110315113049.a6112494.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Mar 2011 11:30:49 +1100

> On Mon, 14 Mar 2011 10:56:12 +0100 (CET) Thomas Gleixner <tglx@linutronix.de> wrote:
>> Yeah, powerpc alone compiles with GENERIC_HARDIRQS_NO_DEPRECATED as it
>> does not have that notify commit.
>> 
>> If you add net which has that notify commit, but not the fix it
>> breaks. I wonder whether Dave should pick that fix into net.
> 
> So, if you merge the commit 1fb0ef31f428 ("genirq: Fix affinity notifier
> fallout") from the tip tree, you will get exactly one new commit and will
> fix your tree properly with no adverse effect on anyone else.

Thomas, how would you like me to do this?  Do you want to put that
commit on a branch for me to pull from or should I apply it
directly?
