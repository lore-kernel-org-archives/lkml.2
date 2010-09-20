Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab0ITQNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 12:13:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46142
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab0ITQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 12:13:48 -0400
Date: Mon, 20 Sep 2010 09:14:07 -0700 (PDT)
Message-Id: <20100920.091407.241426689.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: m.nazarewicz@samsung.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: core: dev.c: use spin_lock_irqsave() rather than
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284998621.3420.539.camel@edumazet-laptop>
References: <ee14e5e38e7a5df520d902ef8a236bbe9ed206fa.1284991149.git.m.nazarewicz@samsung.com>
	<1284998621.3420.539.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 20 Sep 2010 18:03:41 +0200

> Hmm, while your patch is technically correct, it seems strange all this
> stuff runs in hard irq context.

I would much rather this RNDIS query response handler get
scheduled to run into softirq context or similar instead.

I am not applying this patch.
