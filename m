Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab1KXFm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 00:42:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab1KXFm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 00:42:28 -0500
Date: Thu, 24 Nov 2011 00:42:24 -0500 (EST)
Message-Id: <20111124.004224.1561680524524841332.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, buytenh@wantstofly.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: mv643xx_eth: fix build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322106438.16201.11.camel@phoenix>
References: <1322106438.16201.11.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 Nov 2011 21:42:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 24 Nov 2011 11:47:18 +0800

> Fix below build error:
>   CC      drivers/net/ethernet/marvell/mv643xx_eth.o
> drivers/net/ethernet/marvell/mv643xx_eth.c: In function 'mv643xx_eth_get_drvinfo':
> drivers/net/ethernet/marvell/mv643xx_eth.c:1505: error: 'info' undeclared (first use in this function)
> drivers/net/ethernet/marvell/mv643xx_eth.c:1505: error: (Each undeclared identifier is reported only once
> drivers/net/ethernet/marvell/mv643xx_eth.c:1505: error: for each function it appears in.)
> make[4]: *** [drivers/net/ethernet/marvell/mv643xx_eth.o] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
