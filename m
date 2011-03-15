Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab1COWGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:06:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44202
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595Ab1COWGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:06:37 -0400
Date: Tue, 15 Mar 2011 15:07:14 -0700 (PDT)
Message-Id: <20110315.150714.245386974.davem@davemloft.net>
To: tglx@linutronix.de
Cc: sfr@canb.auug.org.au, bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, hpa@zytor.com, peterz@infradead.org
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1103151128070.2787@localhost6.localdomain6>
References: <20110314.210712.226761233.davem@davemloft.net>
	<20110315172558.a11642e7.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.1103151128070.2787@localhost6.localdomain6>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 15 Mar 2011 11:29:18 +0100 (CET)

> On Tue, 15 Mar 2011, Stephen Rothwell wrote:
> 
>> Hi Dave,
>> 
>> On Mon, 14 Mar 2011 21:07:12 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
>> >
>> > From: Stephen Rothwell <sfr@canb.auug.org.au>
>> > Date: Tue, 15 Mar 2011 11:30:49 +1100
>> > 
>> > > So, if you merge the commit 1fb0ef31f428 ("genirq: Fix affinity notifier
>> > > fallout") from the tip tree, you will get exactly one new commit and will
>> > > fix your tree properly with no adverse effect on anyone else.
>> > 
>> > Thomas, how would you like me to do this?  Do you want to put that
>> > commit on a branch for me to pull from or should I apply it
>> > directly?
>> 
>> That commit is already the head of the irq/numa branch in the tip tree
>> (it is also on the irq/core branch).
>> 
>> Please merge that rather than cherry-picking the commit as that will
>> minimise the possibility of conflicts.  Pulling the irq/numa branch will
>> get you just that one fixup commit (as you have already merged up to the
>> immediately preceding commit).
>> 
>> I assume this makes sense, Thomas?  I just did a merge of the actual
>> fixup commit after merging the net tree.
> 
> Yes. irq/numa should do the trick.

Great, I'll do that now.
