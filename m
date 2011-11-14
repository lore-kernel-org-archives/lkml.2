Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1KNFXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:23:16 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43523 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1KNFXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:23:15 -0500
Date: Mon, 14 Nov 2011 00:22:57 -0500 (EST)
Message-Id: <20111114.002257.1441682753359852153.davem@davemloft.net>
To: horti@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.decotigny@google.com, ian.campbell@citrix.com,
        rick.jones2@hp.com, eric.dumazet@gmail.com, maheshb@google.com
Subject: Re: [PATCH net-next v2] net-forcedeth: Add internal loopback
 support for forcedeth NICs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <0a790bcdac9827d6e4a9162cc8f6b5bcb70acd4e.1321063429.git.horti@google.com>
References: <cover.1321063429.git.horti@google.com>
	<0a790bcdac9827d6e4a9162cc8f6b5bcb70acd4e.1321063429.git.horti@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:23:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sanjay Hortikar <horti@google.com>
Date: Fri, 11 Nov 2011 18:11:21 -0800

> Support enabling/disabling/querying internal loopback mode for
> forcedeth NICs using ethtool.
> 
> Signed-off-by: Sanjay Hortikar <horti@google.com>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied, thanks.
