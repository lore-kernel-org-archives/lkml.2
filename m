Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2FSH2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:28:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51333 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2FSH2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:28:18 -0400
Date: Tue, 19 Jun 2012 00:28:17 -0700 (PDT)
Message-Id: <20120619.002817.595558964141813189.davem@davemloft.net>
To: stigge@antcom.de
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] net: lpc_eth: Driver cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340050482-22666-1-git-send-email-stigge@antcom.de>
References: <1340050482-22666-1-git-send-email-stigge@antcom.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Stigge <stigge@antcom.de>
Date: Mon, 18 Jun 2012 22:14:42 +0200

> This patch removes some nowadays superfluous definitions (one unused define and
> an obsolete function forward declaration) and corrects a netdev_err() to
> netdev_dbg().
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Applied.
