Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab1FQDfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:35:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55192 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab1FQDfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:35:46 -0400
Date: Thu, 16 Jun 2011 23:35:42 -0400 (EDT)
Message-Id: <20110616.233542.1974667912524600949.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, sebastian.belden@googlemail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] gianfar: Use pr_<level>, netdev_<level> and
 netif_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1f8bdbed8f110b214daaff8350ae9bde68c9cc12.1308076047.git.joe@perches.com>
References: <1f8bdbed8f110b214daaff8350ae9bde68c9cc12.1308076047.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 16 Jun 2011 20:35:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 14 Jun 2011 11:57:47 -0700

> Use the current logging styles.
> 
> Add #define DEBUG to get same output for <foo>_dbg messages.
> Convert a few bare printks to pr_err.
> 
> Fix a likely copy/paste defect where a test was done with RX values:
>         if (num_rx_qs > MAX_RX_QS) {
> but TX limits were emitted:
>         printk(KERN_ERR "num_rx_qs(=%d) greater than MAX_RX_QS(=%d)\n",
>                               num_tx_qs, MAX_TX_QS);
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
