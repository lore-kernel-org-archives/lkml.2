Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2BEWyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:54:15 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44089 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2BEWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:54:14 -0500
Date: Sun, 05 Feb 2012 17:54:01 -0500 (EST)
Message-Id: <20120205.175401.1607753113306832696.davem@davemloft.net>
To: jj@chaosbits.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sjur.brandeland@stericsson.com, remi.denis-courmont@nokia.com,
        sakari.ailus@nokia.com
Subject: Re: [PATCH] Net: caifdev is never used in
 net/caif/caif_dev.c::transmit() - remove it.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1202052348450.32529@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202052348450.32529@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 05 Feb 2012 14:54:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 5 Feb 2012 23:50:46 +0100 (CET)

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.

I changed the subject prefix to "caif: " and the one for your previous
patch to "decnet: "  Please don't put that "Net, " thing there.
