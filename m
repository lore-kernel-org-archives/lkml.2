Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2D2Bwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 21:52:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54567 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab2D2Bvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 21:51:46 -0400
Date: Sat, 28 Apr 2012 21:49:12 -0400 (EDT)
Message-Id: <20120428.214912.1328835829329133918.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, avictor.za@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH 1/2] AT91: Remove fixed mapping for AT91RM9200 ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <3ad9b1273c4f30d42dcc3bdf6d03470111246f14.1335435759.git.nicolas.ferre@atmel.com>
References: <3ad9b1273c4f30d42dcc3bdf6d03470111246f14.1335435759.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 28 Apr 2012 18:49:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Thu, 26 Apr 2012 12:30:42 +0200

> From: Andrew Victor <avictor.za@gmail.com>
> 
> The AT91RM9200 Ethernet controller still has a fixed IO mapping.
> So:
> * Remove the fixed IO mapping and AT91_VA_BASE_EMAC definition.
> * Pass the physical base-address via platform-resources to the driver.
> * Convert at91_ether.c driver to perform an ioremap().
> * Ethernet PHY detection needs to be performed during the driver
> initialization process, it can no longer be done first.
> 
> Signed-off-by: Andrew Victor <linux@maxim.org.za>
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied to net-next.
