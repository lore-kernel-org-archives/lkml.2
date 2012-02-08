Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2BHXvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:51:01 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49377 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2BHXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:50:58 -0500
Date: Wed, 08 Feb 2012 18:50:55 -0500 (EST)
Message-Id: <20120208.185055.2055806444634975498.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] netdev: ethernet dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <ce53bc956b35497724bbbb76ab07bfc4c5b78291.1328562210.git.netdev@pradeepdalvi.com>
References: <6fbe769a05ae20f89f6112bd2a7ccbb085ed874d.1328445742.git.netdev@pradeepdalvi.com>
	<ce53bc956b35497724bbbb76ab07bfc4c5b78291.1328562210.git.netdev@pradeepdalvi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 15:50:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
Date: Tue,  7 Feb 2012 02:46:48 +0530

> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>   - Removed extra skb->dev = dev after netdev_alloc_skb
> 
> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>

Applied.
