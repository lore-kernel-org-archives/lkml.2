Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab2FKILT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:11:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40627 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2FKILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:11:18 -0400
Date: Mon, 11 Jun 2012 01:11:17 -0700 (PDT)
Message-Id: <20120611.011117.597888637750902318.davem@davemloft.net>
To: stigge@antcom.de
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] net: lpc_eth: Increase number of TX descriptors
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339401793-12258-2-git-send-email-stigge@antcom.de>
References: <1339401793-12258-1-git-send-email-stigge@antcom.de>
	<1339401793-12258-2-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Mon, 11 Jun 2012 10:03:12 +0200

> Since we have enough SRAM, we can increase the number of TX descriptors, so the
> "BUSY" warning about occupied TX descriptors doesn't need to show up as often.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

This is way too terse, and as I described in my reply to your first
patch it is not normal for the transmit function to be invoked when
there are no TX descriptors available.  That's a bug if it is happening.
