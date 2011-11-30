Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1K3FpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:45:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47020 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1K3FpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:45:12 -0500
Date: Wed, 30 Nov 2011 00:40:44 -0500 (EST)
Message-Id: <20111130.004044.1357362466737795134.davem@davemloft.net>
To: plagnioj@jcrosoft.com
Cc: nicolas.ferre@atmel.com, jamie@jamieiles.com, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] at91_ether: use gpio_is_valid for phy IRQ line
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111130044403.GY15008@game.jcrosoft.org>
References: <1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com>
	<20111129.185342.105454076866922618.davem@davemloft.net>
	<20111130044403.GY15008@game.jcrosoft.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 Nov 2011 21:40:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date: Wed, 30 Nov 2011 05:44:03 +0100

> On 18:53 Tue 29 Nov     , David Miller wrote:
>> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Date: Thu, 24 Nov 2011 22:21:14 +0100
>> 
>> > Use the generic gpiolib gpio_is_valid() function to test
>> > if the phy IRQ line GPIO is actually provided.
>> > 
>> > For non-connected or non-existing phy IRQ lines, -EINVAL
>> > value is used for phy_irq_pin field of struct at91_eth_data.
>> > 
>> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> 
>> I'm assuming this goes through the ARM tree, because in both of my networking
>> trees there is no ARM at91 implementation of gpio_is_valid().
> yes the depending patch series is in the arm-soc
> 
> can we have your ack or sob?

Acked-by: David S. Miller <davem@davemloft.net>
