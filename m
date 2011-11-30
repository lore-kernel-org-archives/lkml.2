Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1K3WZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:25:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56082 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1K3WZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:25:41 -0500
Date: Wed, 30 Nov 2011 17:24:46 -0500 (EST)
Message-Id: <20111130.172446.1238507297139601019.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: miles.lane@gmail.com, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com,
        netdev@vger.kernel.org
Subject: Re: 3.2.0-rc3+ (Linus git -
 883381d9f1c5a6329bbb796e23ae52c939940310) - INFO: suspicious RCU usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322633155.23721.5.camel@edumazet-laptop>
References: <CAHFgRy-hAMF344eChZ9tLnFB7qUS_v3m0LvtBKWjbFmBeeASsA@mail.gmail.com>
	<1322632602.23721.0.camel@edumazet-laptop>
	<1322633155.23721.5.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 30 Nov 2011 14:24:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Nov 2011 07:05:55 +0100

> [PATCH] ipv4: fix lockdep splat in rt_cache_seq_show
> 
> After commit f2c31e32b378 (fix NULL dereferences in check_peer_redir()),
> dst_get_neighbour() should be guarded by rcu_read_lock() /
> rcu_read_unlock() section.
> 
> Reported-by: Miles Lane <miles.lane@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
