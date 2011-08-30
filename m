Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab1H3C5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:57:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33756 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1H3C5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:57:15 -0400
Date: Mon, 29 Aug 2011 22:55:10 -0400 (EDT)
Message-Id: <20110829.225510.1534815133945067081.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: rdunlap@xenotime.net, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: fix Makefile typos & build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110830115925.45984bb8eeb73401dd5d289f@canb.auug.org.au>
References: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
	<20110829114940.4d29febc.rdunlap@xenotime.net>
	<20110830115925.45984bb8eeb73401dd5d289f@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 29 Aug 2011 19:55:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 30 Aug 2011 11:59:25 +1000

> It may be my old(er) eyes, but isn't that CONFIG_SLIP line repeated?

My old eyes can confirm this, so I'll fix it up, thanks! :-)
