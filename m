Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1KCWJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:09:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36691 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab1KCWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:09:52 -0400
Date: Thu, 03 Nov 2011 18:09:47 -0400 (EDT)
Message-Id: <20111103.180947.1752241500828191615.davem@davemloft.net>
To: tony@atomide.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: Add back alignment for size for __alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111102234028.GP31337@atomide.com>
References: <20111102232403.GO31337@atomide.com>
	<4EB1D2C7.2070700@gmail.com>
	<20111102234028.GP31337@atomide.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 Nov 2011 15:09:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>
Date: Wed, 2 Nov 2011 16:40:28 -0700

> Subject: [PATCH] net: Add back alignment for size for __alloc_skb

Applied, thanks a lot!
