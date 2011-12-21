Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1LUUrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:47:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55154 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab1LUUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:47:39 -0500
Date: Wed, 21 Dec 2011 15:47:34 -0500 (EST)
Message-Id: <20111221.154734.248295514779001007.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: richard.weinberger@gmail.com, gladewitz@gmx.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel-DOS error in arp mechanism
 =?iso-2022-jp-3?B?GyQoUSN8GyhC?= no delete off incomplete arp adresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324461072.2728.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1324453467.2610.20.camel@edumazet-laptop>
	<20111221.030727.1528369698756365464.davem@davemloft.net>
	<1324461072.2728.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 12:47:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 21 Dec 2011 10:51:12 +0100

> [PATCH] ipv4: reintroduce route cache garbage collector
> 
> Commit 2c8cec5c10b (ipv4: Cache learned PMTU information in inetpeer)
> removed IP route cache garbage collector a bit too soon, as this gc was
> responsible for expired routes cleanup, releasing their neighbour
> reference.
> 
> As pointed out by Robert Gladewitz, recent kernels can fill and exhaust
> their neighbour cache.
> 
> Reintroduce the garbage collection, since we'll have to wait our
> neighbour lookups become refcount-less to not depend on this stuff.
> 
> Reported-by: Robert Gladewitz <gladewitz@gmx.de>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
