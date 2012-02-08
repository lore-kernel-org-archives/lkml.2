Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab2BHXuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:50:54 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab2BHXux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:50:53 -0500
Date: Wed, 08 Feb 2012 18:50:50 -0500 (EST)
Message-Id: <20120208.185050.869030284425092445.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/5] netdev: ethernet dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <16d58f0e1810fcefbe4e2028a5690caad37d2c34.1328562210.git.netdev@pradeepdalvi.com>
References: <d8ad7b1e88df72e284cbc8b8fba1745530923375.1328445742.git.netdev@pradeepdalvi.com>
	<16d58f0e1810fcefbe4e2028a5690caad37d2c34.1328562210.git.netdev@pradeepdalvi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 15:50:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
Date: Tue,  7 Feb 2012 02:46:13 +0530

> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>   - Removed extra skb->dev = dev after netdev_alloc_skb
> 
> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>

Applied.
