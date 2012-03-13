Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab2CMANz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:13:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53115 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2CMANy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:13:54 -0400
Date: Mon, 12 Mar 2012 17:08:47 -0700 (PDT)
Message-Id: <20120312.170847.850148121128150069.davem@davemloft.net>
To: stigge@antcom.de
Cc: netdev@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de, baruch@tkos.co.il,
        joe@perches.com, bhutchings@solarflare.com, florian@openwrt.org
Subject: Re: [PATCH v7] lpc32xx: Added ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331243357-27497-1-git-send-email-stigge@antcom.de>
References: <1331243357-27497-1-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 17:08:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Thu,  8 Mar 2012 22:49:17 +0100

> This patch adds an ethernet driver for the LPC32xx ARM SoC.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied to net-next, thanks.
