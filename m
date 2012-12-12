Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab2LLFPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 00:15:55 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46458 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2LLFPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 00:15:54 -0500
Date: Wed, 12 Dec 2012 00:15:50 -0500 (EST)
Message-Id: <20121212.001550.741463250196231082.davem@davemloft.net>
To: tipecaml@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-net-drivers@solarflare.com, bhutchings@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] net: sfc: fix return value check in
 efx_ptp_probe_channel().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355271894-5284-5-git-send-email-tipecaml@gmail.com>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
	<1355271894-5284-5-git-send-email-tipecaml@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyril Roelandt <tipecaml@gmail.com>
Date: Wed, 12 Dec 2012 01:24:53 +0100

> The ptp_clock_register() returns ERR_PTR() and never returns NULL. Replace the
> NULL check by a call to IS_ERR().
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

I'll let Ben queue this up.

Probably he'll want to avoid potentially leaving an ERR_PTR
in ptp->phc_clock even if, with this fix, that would be
harmless.
