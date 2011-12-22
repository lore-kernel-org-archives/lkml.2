Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1LVSbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:31:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:36810 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1LVSbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:31:15 -0500
Date: Thu, 22 Dec 2011 13:29:50 -0500 (EST)
Message-Id: <20111222.132950.2105811163837575839.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: bootc@bootc.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 ipv6_select_ident
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324575692.2586.6.camel@edumazet-laptop>
References: <1324563353.2153.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<4EF352A2.2090604@bootc.net>
	<1324575692.2586.6.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 10:30:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 22 Dec 2011 18:41:32 +0100

> IPv6 needs multicast capabilities, so maybe balance-rr bonding mode is
> not propagating multicat filters properly on both nics.
> 
> It might be a problem on one of your NIC.

This is my impression too, definitely some kind of multicast problem.
