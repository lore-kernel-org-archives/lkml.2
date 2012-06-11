Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab2FKJD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:03:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40969 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2FKJD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:03:56 -0400
Date: Mon, 11 Jun 2012 02:03:52 -0700 (PDT)
Message-Id: <20120611.020352.1962768244524496467.davem@davemloft.net>
To: stigge@antcom.de
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] net: lpc_eth: Replace WARN() trace with simple
 pr_warn()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FD5AE1D.9030807@antcom.de>
References: <1339401793-12258-1-git-send-email-stigge@antcom.de>
	<1339403108.6001.1697.camel@edumazet-glaptop>
	<4FD5AE1D.9030807@antcom.de>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Mon, 11 Jun 2012 10:36:45 +0200

> But maybe this is wrong. Can you please give me a hint how the net
> subsystem makes sure that this doesn't happen under normal circumstances?

Well if you are asking this question then you didn't read my feedback,
because I explained exactly what prevents this.
