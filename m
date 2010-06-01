Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0FAH2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:28:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57756
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab0FAH2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:28:14 -0400
Date: Tue, 01 Jun 2010 00:28:23 -0700 (PDT)
Message-Id: <20100601.002823.124079598.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: Luis.Rodriguez@atheros.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next]atl1c: Add AR8151 v2 support and change L0s/L1
 routine
From: David Miller <davem@davemloft.net>
In-Reply-To: <12752881361777-git-send-email-jie.yang@atheros.com>
References: <12752881361777-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Mon, 31 May 2010 14:42:16 +0800

> From: Jie.Yang@atheros.com
> 
> Add AR8151 v2.0 Gigabit 1000 support
> Change jumbo frame size to 6K
> Update L0s/L1 rountine
>         when link speed is 100M or 1G, set L1 link timer to 4 for l1d_2 and l2c_b2
>         set L1 link timer to 7 for l2c_b, set L1 link timer to 0xF for others.
> Update atl1c_suspend routine
> 	just refactory the function, add atl1c_phy_power_saving routine,
> 	when Wake On Lan enable, this func will be called to save power,
> 	it will reautoneg PHY to 10/100M speed depend on the link
> 	partners link capability.
> Update atl1c_configure_des_ring
>         do not use l2c_b default SRAM configuration.
> 
> Signed-off-by: Jie.Yang@atheros.com

Applied, thank you.
