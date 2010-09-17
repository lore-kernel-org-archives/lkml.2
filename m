Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0IQEq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 00:46:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59632
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab0IQEqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 00:46:11 -0400
Date: Thu, 16 Sep 2010 21:46:29 -0700 (PDT)
Message-Id: <20100916.214629.236248452.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nbowler@elliptictech.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Regression, bisected: WARNING spam with ipsec since 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284676070.4784.25.camel@edumazet-laptop>
References: <20100916213138.GA6605@elliptictech.com>
	<1284676070.4784.25.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 17 Sep 2010 00:27:50 +0200

> [PATCH] xfrm: dont assume rcu_read_lock in xfrm_output_one()
> 
> ip_local_out() is called with rcu_read_lock() held from ip_queue_xmit()
> but not from other call sites.
> 
> Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
