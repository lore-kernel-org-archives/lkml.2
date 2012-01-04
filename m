Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2ADX6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:58:38 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49532 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757298Ab2ADX6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:58:37 -0500
Message-ID: <1325721515.4116.11.camel@joe2Laptop>
Subject: Re: [PATCH 4/6] ath6kl: get rid of AR_DBG_LVL_CHECK()
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linville@tuxdriver.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, ath6kl-devel@qualcomm.com,
        davem@davemloft.net
Date: Wed, 04 Jan 2012 15:58:35 -0800
In-Reply-To: <20120104230921.32306.63985.stgit@x201>
References: <20120104230429.32306.75965.stgit@x201>
	 <20120104230921.32306.63985.stgit@x201>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 01:09 +0200, Kalle Valo wrote:
> We don't need it as debug calls already have a log level and compiler
> should be smart enough to optimise away the code when ath6kl debug code
> is not enabled. Also it makes it easier to abstract core code to
> ath6kl_core.ko.

Changelog isn't representative of code changes.
ATH6KL_DBG_ANY -> ATH6KL_DBG_IRQ.

> diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
[]
> @@ -82,31 +82,31 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
>  			   struct ath6kl_irq_enable_reg *irq_enable_reg)
>  {
>  
> -	ath6kl_dbg(ATH6KL_DBG_ANY, ("<------- Register Table -------->\n"));
> +	ath6kl_dbg(ATH6KL_DBG_IRQ, ("<------- Register Table -------->\n"));

etc...


