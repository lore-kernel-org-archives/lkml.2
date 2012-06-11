Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2FKUN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:13:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45804 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2FKUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:13:56 -0400
Date: Mon, 11 Jun 2012 13:13:55 -0700 (PDT)
Message-Id: <20120611.131355.1151863180696891268.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: stigge@antcom.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: lpc_eth: fix tx completion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339435296.6001.2484.camel@edumazet-glaptop>
References: <4FD5AE1D.9030807@antcom.de>
	<1339404835.6001.1788.camel@edumazet-glaptop>
	<1339435296.6001.2484.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 11 Jun 2012 19:21:36 +0200

> From: Eric Dumazet <edumazet@google.com>
> 
> __lpc_handle_xmit() has two bugs :
> 
> 1) It can leak skbs in case TXSTATUS_ERROR is set
> 
> 2) It can wake up txqueue while no slot was freed.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Roland Stigge <stigge@antcom.de>
> Tested-by: Roland Stigge <stigge@antcom.de>

Applied and queued up for -stable.
