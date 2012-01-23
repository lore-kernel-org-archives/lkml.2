Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2AWSyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:54:03 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57391 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2AWSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:54:01 -0500
Date: Mon, 23 Jan 2012 13:53:50 -0500 (EST)
Message-Id: <20120123.135350.756110788533975068.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@pradeepdalvi.com, netdev@vger.kernel.org, hch@lst.de,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH/RESEND] drivers/net/ethernet: dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327344034.6317.3.camel@joe2Laptop>
References: <1327343283-4830-1-git-send-email-netdev@pradeepdalvi.com>
	<1327344034.6317.3.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Jan 2012 10:53:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 23 Jan 2012 10:40:34 -0800

> Perhaps you should break this large patch
> into multiple separate patches.

Agreed, this patch is way too large especially for what is obviously
turning out to be a very non-trivial transformation in some cases
and also new patch submitters should generally avoid large patches
like this.
