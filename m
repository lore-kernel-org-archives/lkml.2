Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab1LGScS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:32:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1LGScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:32:17 -0500
Date: Wed, 07 Dec 2011 13:27:39 -0500 (EST)
Message-Id: <20111207.132739.335219058075173468.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com
Subject: Re: [PATCH v3 1/2] net/macb: add DT support for Cadence macb/gem
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <714ca7492d8d45b50eab34448c4b70933ce5701c.1323086095.git.nicolas.ferre@atmel.com>
References: <1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com>
	<714ca7492d8d45b50eab34448c4b70933ce5701c.1323086095.git.nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Dec 2011 10:27:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Mon,  5 Dec 2011 12:59:52 +0100

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Allow the device tree to provide the mac address and the phy mode.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> [nicolas.ferre@atmel.com: change "compatible" node property, doc and DT hwaddr]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> [jamie@jamieiles.com: add "gem" compatibility strings and doc]
> Acked-by: Jamie Iles<jamie@jamieiles.com>

Acked-by: David S. Miller <davem@davemloft.net>
