Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab1GAWbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:31:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45104 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab1GAWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:31:14 -0400
Date: Fri, 01 Jul 2011 15:31:10 -0700 (PDT)
Message-Id: <20110701.153110.1360455002202861127.davem@davemloft.net>
To: joe@perches.com
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] netpoll: Trivial updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309558703.7277.78.camel@Joe-Laptop>
References: <4E0D43C3.5090502@redhat.com>
	<20110701.000646.268663722441785795.davem@davemloft.net>
	<1309558703.7277.78.camel@Joe-Laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 01 Jul 2011 15:31:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 01 Jul 2011 15:18:23 -0700

> These are inlined and dependent on CONFIG_NET_POLL_CONTROLLER
> in drivers/net/Kconfig so doesn't netpoll_send_skb_on_dev need
> to be SYMBOL_EXPORTed?

Right I noticed this when I read the rest of the thread
where this was discussed.
