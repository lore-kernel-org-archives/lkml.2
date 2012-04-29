Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2D2Bvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 21:51:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54566 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2D2Bvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 21:51:45 -0400
Date: Sat, 28 Apr 2012 21:49:28 -0400 (EDT)
Message-Id: <20120428.214928.225764794994822879.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, avictor.za@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH 2/2] net/at91_ether: use gpio_to_irq for phy IRQ line
From: David Miller <davem@davemloft.net>
In-Reply-To: <cfc991548b5b73c8038f41877da1cd0104945cf5.1335435759.git.nicolas.ferre@atmel.com>
References: <3ad9b1273c4f30d42dcc3bdf6d03470111246f14.1335435759.git.nicolas.ferre@atmel.com>
	<cfc991548b5b73c8038f41877da1cd0104945cf5.1335435759.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 28 Apr 2012 18:49:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Thu, 26 Apr 2012 12:30:43 +0200

> Use the gpio_to_irq() function to retrieve the phy IRQ line
> from the GPIO pin specification.
> This fix is needed now that we have moved to irqdomains on AT91.
> 
> Reported-by: Jamie Iles <jamie@jamieiles.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied to net-next.
