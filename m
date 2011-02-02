Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab1BBVvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:51:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54356
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab1BBVvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:51:01 -0500
Date: Wed, 02 Feb 2011 13:51:37 -0800 (PST)
Message-Id: <20110202.135137.104048665.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com,
        lethal@linux-sh.org
Subject: Re: [PATCH] softirq: Avoid stack switch from ksoftirqd
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
References: <alpine.LFD.2.00.1102021704530.31804@localhost6.localdomain6>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 2 Feb 2011 17:10:48 +0100 (CET)

> ksoftirqd() calls do_softirq() which switches stacks on several
> architectures. That makes no sense at all. ksoftirqd's stack is
> sufficient.
> 
> Call __do_softirq() directly.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
