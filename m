Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab0HQWOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:14:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48205
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292Ab0HQWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:14:14 -0400
Date: Tue, 17 Aug 2010 15:14:31 -0700 (PDT)
Message-Id: <20100817.151431.39165935.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        peterz@infradead.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1281990130.2487.70.camel@edumazet-laptop>
References: <1281883637.2942.42.camel@edumazet-laptop>
	<20100816.123607.57459160.davem@davemloft.net>
	<1281990130.2487.70.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 16 Aug 2010 22:22:10 +0200

> [PATCH] netfilter: {ip,ip6,arp}_tables: avoid lockdep false positive
> 
> After commit 24b36f019 (netfilter: {ip,ip6,arp}_tables: dont block
> bottom half more than necessary), lockdep can raise a warning
> because we attempt to lock a spinlock with BH enabled, while
> the same lock is usually locked by another cpu in a softirq context.
> 
> Disable again BH to avoid these lockdep warnings.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Diagnosed-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Since Patrick seems to be busy, I'll merge this directly into
net-2.6, thanks everyone!
