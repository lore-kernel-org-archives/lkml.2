Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1LBSC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:02:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47407 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1LBSC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:02:58 -0500
Date: Fri, 02 Dec 2011 12:58:32 -0500 (EST)
Message-Id: <20111202.125832.1208514279272697863.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com
Subject: Re: [PATCH v2] net/macb: add DT support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com>
References: <1322846050-4543-1-git-send-email-nicolas.ferre@atmel.com>
	<1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 02 Dec 2011 09:58:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Fri,  2 Dec 2011 18:43:02 +0100

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Allow the device tree to provide the mac address and the phy mode.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> [nicolas.ferre@atmel.com: change "compatible" node property, doc and DT hwaddr]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jamie Iles <jamie@jamieiles.com>
> ---
> v2: modify macb_get_hwaddr_dt() parameter

You'll have to respin these two macb patches, as they don't apply properly
to the net-next tree which is where they should be targetted.

Thanks.
