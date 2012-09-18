Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2IRUZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:25:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46800 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab2IRUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:25:17 -0400
Date: Tue, 18 Sep 2012 16:25:14 -0400 (EDT)
Message-Id: <20120918.162514.1950372124026735732.davem@davemloft.net>
To: mst@redhat.com
Cc: edumazet@google.com, bhutchings@solarflare.com, mirq-linux@rere.qmqm.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix memory leak on oom with zerocopy
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120916084416.GA22936@redhat.com>
References: <20120916084416.GA22936@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 16 Sep 2012 11:44:16 +0300

> If orphan flags fails, we don't free the skb
> on receive, which leaks the skb memory.
> 
> Return value was also wrong: netif_receive_skb
> is supposed to return NET_RX_DROP, not ENOMEM.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks Michael.
