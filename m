Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2DAUUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:20:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44480 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2DAUUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:20:52 -0400
Date: Sun, 01 Apr 2012 16:17:14 -0400 (EDT)
Message-Id: <20120401.161714.1988118567020406881.davem@davemloft.net>
To: stigge@antcom.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: lpc_eth: Fix rename of dev_hw_addr_random
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332974186-12962-1-git-send-email-stigge@antcom.de>
References: <1332974186-12962-1-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 13:17:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Thu, 29 Mar 2012 00:36:26 +0200

> In parallel to the integration of lpc_eth.c, dev_hw_addr_random() has been
> renamed to eth_hw_addr_random(). This patch fixes it also in the new driver
> lpc_eth.c.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied and queued up for -stable.
