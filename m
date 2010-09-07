Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab0IGQ2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:28:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54961
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757942Ab0IGQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:28:36 -0400
Date: Tue, 07 Sep 2010 09:28:53 -0700 (PDT)
Message-Id: <20100907.092853.104061734.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        peterz@infradead.org, hch@infradead.org, netdev@vger.kernel.org
Subject: Re: [patch 08/30] net: ppp_async: semaphore cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100907125055.460765783@linutronix.de>
References: <20100907124636.880953480@linutronix.de>
	<20100907125055.460765783@linutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 07 Sep 2010 14:32:22 -0000

> Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
