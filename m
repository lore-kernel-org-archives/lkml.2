Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2HNVqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:46:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38467 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2HNVqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:46:24 -0400
Date: Tue, 14 Aug 2012 14:46:23 -0700 (PDT)
Message-Id: <20120814.144623.1855051650444819552.davem@davemloft.net>
To: shchepetkov@ispras.ru
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] net: Fix incorrect comment in netif_tx_stop_queue()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344869014-7110-1-git-send-email-shchepetkov@ispras.ru>
References: <1344869014-7110-1-git-send-email-shchepetkov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ilya Shchepetkov <shchepetkov@ispras.ru>
Date: Mon, 13 Aug 2012 18:43:34 +0400

> netif_stop_queue() can be called before register_netdev() because now
> TX queues are allocated inside alloc_netdev_mqs().
> 
> (since ed9af2e839c06c18f721da2c768fbb444c4a10e5 commit)
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Ilya Shchepetkov <shchepetkov@ispras.ru>

You're not changing a "comment", you're changing a kernel log message.

Have you actually triggered this condition?

I doubt it, and I'm not applying this patch.
