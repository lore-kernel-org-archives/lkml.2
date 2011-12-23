Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab1LWDj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 22:39:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40350 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab1LWDjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 22:39:53 -0500
Date: Thu, 22 Dec 2011 22:38:29 -0500 (EST)
Message-Id: <20111222.223829.536447332324142274.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bootc@bootc.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324563353.2153.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1324528656.2621.19.camel@edumazet-laptop>
	<4EF300B2.3050903@bootc.net>
	<1324563353.2153.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 19:39:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 22 Dec 2011 15:15:53 +0100

> [PATCH] net: introduce DST_NOPEER dst flag
> 
> Chris Boot reported crashes occurring in ipv6_select_ident().
 ...
> This is caused by bridge netfilter special dst_entry (fake_rtable), a
> special shared entry, where attaching an inetpeer makes no sense.
> 
> Problem is present since commit 87c48fa3b46 (ipv6: make fragment
> identifications less predictable)
> 
> Introduce DST_NOPEER dst flag and make sure ipv6_select_ident() and
> __ip_select_ident() fallback to the 'no peer attached' handling.
> 
> Reported-by: Chris Boot <bootc@bootc.net>
> Tested-by: Chris Boot <bootc@bootc.net>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
