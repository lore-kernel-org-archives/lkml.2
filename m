Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2CIVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:51:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50641 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2CIVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:51:27 -0500
Date: Fri, 09 Mar 2012 13:51:23 -0800 (PST)
Message-Id: <20120309.135123.2098113809216101768.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 1/2] net/hyperv: Fix data corruption in
 rndis_filter_receive()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331328437-26852-1-git-send-email-haiyangz@microsoft.com>
References: <1331328437-26852-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 09 Mar 2012 13:51:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri,  9 Mar 2012 13:27:16 -0800

> Limiting the memcpy to be the sizeof(struct rndis_message) can truncate
> the message if there are Per-Packet-Info or Out-of-Band data.
> 
> In my earlier patch (commit 45326342), the unnecessary kmap_atomic and
> kunmap_atomic surrounding this memcpy have been removed because the memory
> in the receive buffer is always mapped. This memcpy is not necessary
> either. To fix the bug, I removed the memcpy.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Well, where the heck is patch 2/2?
