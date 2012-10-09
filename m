Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab2JIEVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:21:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33251 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2JIEVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:21:53 -0400
Date: Tue, 09 Oct 2012 00:21:51 -0400 (EDT)
Message-Id: <20121009.002151.1744939534508464049.davem@davemloft.net>
To: mikey@neuling.org
Cc: edumazet@google.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, mbizon@freebox.fr,
        linuxppc-dev@ozlabs.org
Subject: Re: net: fix typo in freescale/ucc_geth.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <23452.1349740345@neuling.org>
References: <20121008173653.1d17895964980c98af59c8ea@canb.auug.org.au>
	<23452.1349740345@neuling.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Neuling <mikey@neuling.org>
Date: Tue, 09 Oct 2012 10:52:25 +1100

> The following patch: 
>   acb600d net: remove skb recycling
> added dev_free_skb() to drivers/net/ethernet/freescale/ucc_geth.c
> 
> This is a typo and should be dev_kfree_skb().  This fixes this.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>

Applied, thanks a lot.
