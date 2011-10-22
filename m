Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1JVHa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:30:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45214 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1JVHaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:30:23 -0400
Date: Sat, 22 Oct 2011 03:30:20 -0400 (EDT)
Message-Id: <20111022.033020.2073551679260143993.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ari.m.savolainen@gmail.com, roy.qing.li@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tg3: fix tigon3_dma_hwbug_workaround()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319268338.6180.20.camel@edumazet-laptop>
References: <CAEbykaVJneQ0ozUvYh2PRn-p_BowL4z4_4Y8EFCdO9mOsNX7OQ@mail.gmail.com>
	<1319265470.6180.13.camel@edumazet-laptop>
	<1319268338.6180.20.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 22 Oct 2011 00:30:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sat, 22 Oct 2011 09:25:38 +0200

> Ari got kernel panics using tg3 NIC, and bisected to 2669069aacc9 "tg3:
> enable transmit time stamping."
> 
> This is because tigon3_dma_hwbug_workaround() might alloc a new skb and
> free the original. We panic when skb_tx_timestamp() is called on freed
> skb.
> 
> Reported-by: Ari Savolainen <ari.m.savolainen@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
