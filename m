Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2C0Wvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:51:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46536 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab2C0Wvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:51:31 -0400
Date: Tue, 27 Mar 2012 18:51:29 -0400 (EDT)
Message-Id: <20120327.185129.633367112180291954.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120325.175151.853542033329072696.davem@davemloft.net>
References: <20120325.175151.853542033329072696.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Mar 2012 15:51:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 25 Mar 2012 17:51:51 -0400 (EDT)

> 1) Name string overrun fix in gianfar driver from Joe Perches.
 ...
> 
> Please pull, thanks a lot!

I don't know if you've pulled this or not, but I just wanted to let
you know that I just added the following critical fix to my tree
which I'd like to propagate to -stable ASAP.

So if you have pulled, if you would repull to get this guy, I'd
really appreciate it.

Thanks a lot!

The following changes since commit 50269e19ad990e79eeda101fc6df80cffd5d4831:

  net: add a truesize parameter to skb_add_rx_frag() (2012-03-25 13:29:58 -0400)

are available in the git repository at:
  gitolite@ra.kernel.org:/pub/scm/linux/kernel/git/davem/net.git master

Eric Dumazet (1):
      net: fix a potential rcu_read_lock() imbalance in rt6_fill_node()

 net/ipv6/route.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)
