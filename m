Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab2FASXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:23:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43030 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933595Ab2FASXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:23:13 -0400
Date: Fri, 01 Jun 2012 14:23:11 -0400 (EDT)
Message-Id: <20120601.142311.630705811475752099.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 1/2] 8139cp: set ring address before enabling receiver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120601041939.4311.55827.stgit@dhcp-8-146.nay.redhat.com>
References: <20120601041939.4311.55827.stgit@dhcp-8-146.nay.redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 01 Jun 2012 12:19:39 +0800

> Currently, we enable the receiver before setting the ring address which could
> lead the card DMA into unexpected areas. Solving this by set the ring address
> before enabling the receiver.
> 
> btw. I find and test this in qemu as I didn't have a 8139cp card in hand. please
> review it carefully.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I hate bugs like this, the other common issue is enabling interrupts
before the chip is fully programmed.

Applied, thanks.
