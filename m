Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab2BBTo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:44:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45015 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab2BBToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:44:25 -0500
Date: Thu, 02 Feb 2012 14:44:21 -0500 (EST)
Message-Id: <20120202.144421.1927599803285674106.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net/hyperv: Use netif_tx_disable() instead of
 netif_stop_queue() when necessary
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328203080-801-1-git-send-email-haiyangz@microsoft.com>
References: <1328203080-801-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Feb 2012 11:44:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu,  2 Feb 2012 09:17:59 -0800

> For code path not on the xmit, use netif_tx_disable() instead of
> netif_stop_queue() to ensure other CPUs are not doing xmit.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
