Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab2FKTS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:18:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35022 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2FKTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:18:55 -0400
Subject: Re: [PATCH 1/3] net: lpc_eth: Replace WARN() trace with simple
 pr_warn()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4FD5B9C8.4020800@antcom.de>
References: <1339401793-12258-1-git-send-email-stigge@antcom.de>
	 <1339403108.6001.1697.camel@edumazet-glaptop> <4FD5AE1D.9030807@antcom.de>
	 <20120611.020352.1962768244524496467.davem@davemloft.net>
	 <4FD5B9C8.4020800@antcom.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jun 2012 21:18:48 +0200
Message-ID: <1339442328.6001.2602.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 11:26 +0200, Roland Stigge wrote:

> Is it sensible at this point to increase the TX buffers anyway? For
> different reasons of course: We have enough SRAM available and TX
> buffers (16->32) are still more than RX buffers (48).

I doubt it has any impact on performance for a 100Mbit link ?

One thing that could be done would be to free skbs in
lpc_eth_hard_start_xmit() instead of __lpc_handle_xmit()



