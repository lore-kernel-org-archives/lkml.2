Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab1K2X6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:58:15 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44712 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab1K2X6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:58:11 -0500
Date: Tue, 29 Nov 2011 18:53:42 -0500 (EST)
Message-Id: <20111129.185342.105454076866922618.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: jamie@jamieiles.com, netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] at91_ether: use gpio_is_valid for phy IRQ line
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com>
References: <1322128098-17724-1-git-send-email-jamie@jamieiles.com>
	<1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 Nov 2011 15:53:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Thu, 24 Nov 2011 22:21:14 +0100

> Use the generic gpiolib gpio_is_valid() function to test
> if the phy IRQ line GPIO is actually provided.
> 
> For non-connected or non-existing phy IRQ lines, -EINVAL
> value is used for phy_irq_pin field of struct at91_eth_data.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I'm assuming this goes through the ARM tree, because in both of my networking
trees there is no ARM at91 implementation of gpio_is_valid().
