Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab2KCTES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 15:04:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57815 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2KCTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 15:04:16 -0400
Date: Sat, 03 Nov 2012 15:04:14 -0400 (EDT)
Message-Id: <20121103.150414.707741347606909244.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, havard@skinnemoen.net, bhutchings@solarflare.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
        manabian@gmail.com
Subject: Re: [PATCH] net/at91_ether: fix the use of macb structure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1351596628-3405-1-git-send-email-nicolas.ferre@atmel.com>
References: <75eb5df193c504e68ebff7d6a6a88d9a1cc678cb.1351591858.git.nicolas.ferre@atmel.com>
	<1351596628-3405-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Tue, 30 Oct 2012 12:30:28 +0100

> Due to the use of common structure in at91_ether and macb drivers,
> change the name of DMA descriptor structures in at91_ether as well:
> dma_desc => macb_dma_desc
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

This does not apply to net-next, respin it if this change is
still relevant.
