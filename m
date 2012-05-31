Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab2EaWVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 18:21:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52341 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab2EaWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 18:21:52 -0400
Date: Thu, 31 May 2012 18:21:45 -0400 (EDT)
Message-Id: <20120531.182145.119572313886189417.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, edumazet@google.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [V2 PATCH] net: sock: validate data_len before allocating skb
 in sock_alloc_send_pskb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120531071809.6392.26677.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120531071809.6392.26677.stgit@amd-6168-8-1.englab.nay.redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 31 May 2012 15:21:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 31 May 2012 15:18:10 +0800

> We need to validate the number of pages consumed by data_len, otherwise frags
> array could be overflowed by userspace. So this patch validate data_len and
> return -EMSGSIZE when data_len may occupies more frags than MAX_SKB_FRAGS.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied and queued up for -stable.

Please do not add explicit stable CC:'s to networking patches, I queue
appropriate changes up myself, and submit them only when I feel that
the change has had sufficient exposure and testing in Linus's tree.
