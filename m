Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2IGVZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:25:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41677 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab2IGVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:25:08 -0400
Date: Fri, 07 Sep 2012 17:25:06 -0400 (EDT)
Message-Id: <20120907.172506.1680438781148301994.davem@davemloft.net>
To: timur@freescale.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, rdunlap@xenotime.net
Subject: Re: [PATCH] netdev/phy: mdio-mux-mmioreg.c should include
 of_address.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1347048592-22957-1-git-send-email-timur@freescale.com>
References: <1347048592-22957-1-git-send-email-timur@freescale.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timur Tabi <timur@freescale.com>
Date: Fri, 7 Sep 2012 15:09:52 -0500

> mdio-mux-mmioreg.c uses function of_address_to_resource(), which is defined
> in linux/of_address.h.  This fixes a compilation error:
> 
> drivers/net/phy/mdio-mux-mmioreg.c: In function 'mdio_mux_mmioreg_probe':
> drivers/net/phy/mdio-mux-mmioreg.c:83:2: error: implicit declaration of
> 	function 'of_address_to_resource'
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>

Please provide "Reported-by: ..." tags to give credit to the problem
reporter, Randy Dunlap in this case.
