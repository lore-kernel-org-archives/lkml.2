Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0CZDcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:32:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42651
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab0CZDcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:32:50 -0400
Date: Thu, 25 Mar 2010 20:33:13 -0700 (PDT)
Message-Id: <20100325.203313.186750805.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       andi@firstfloor.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1003251339470.3721@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003251206550.3721@i5.linux-foundation.org>
	<20100325.124220.258885098.davem@davemloft.net>
	<alpine.LFD.2.00.1003251339470.3721@i5.linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Mar 2010 13:40:43 -0700 (PDT)

> It makes _all_ interrupts act like IRQF_DISABLED. So it actually fixes 
> your issue, by making IRQF_DISABLE a no-op - not because it doesn't exist 
> any more, but because the non-IRQF_DISABLED case would not exist any more.

Yep, Peter Z. explained this to me under seperate cover.

Great!


