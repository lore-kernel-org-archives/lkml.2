Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab2HHXIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:08:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47601 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313Ab2HHXIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:08:05 -0400
Date: Wed, 08 Aug 2012 16:08:04 -0700 (PDT)
Message-Id: <20120808.160804.27739743623506268.davem@davemloft.net>
To: stigge@antcom.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] lpc_eth: remove obsolete ifdefs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344431934-16748-1-git-send-email-stigge@antcom.de>
References: <1344431934-16748-1-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Wed,  8 Aug 2012 15:18:54 +0200

> The #ifdefs regarding CONFIG_ARCH_LPC32XX_MII_SUPPORT and
> CONFIG_ARCH_LPC32XX_IRAM_FOR_NET are obsolete since the symbols have been
> removed from Kconfig and replaced by devicetree based configuration.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied, thanks.
