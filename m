Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2BHUYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:24:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47348 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2BHUYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:24:02 -0500
Date: Wed, 08 Feb 2012 15:23:58 -0500 (EST)
Message-Id: <20120208.152358.916104383646981710.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mace: Fix build for mace due to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328695395-2565-1-git-send-email-netdev@pradeepdalvi.com>
References: <1328695395-2565-1-git-send-email-netdev@pradeepdalvi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 08 Feb 2012 12:24:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
Date: Wed,  8 Feb 2012 15:33:15 +0530

> Refs:
> 1. pmac32_defconfig
> http://kisskb.ellerman.id.au/kisskb/buildresult/5583746/
> 2. ppc6xx_defconfig
> http://kisskb.ellerman.id.au/kisskb/buildresult/5584116/
> 
> Confirmed any such occurances from all failed defconfigs &
> in net-next sources with
> grep -nrs "netdev_alloc_skb" drivers/net/ethernet/ | grep -v ","
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>

Applied.
