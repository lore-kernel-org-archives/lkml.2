Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1H2UVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:21:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49709 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1H2UVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:21:31 -0400
Date: Mon, 29 Aug 2011 16:19:21 -0400 (EDT)
Message-Id: <20110829.161921.655406241861191474.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: fix Makefile typos & build errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110829114940.4d29febc.rdunlap@xenotime.net>
References: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
	<20110829114940.4d29febc.rdunlap@xenotime.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 29 Aug 2011 13:19:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 29 Aug 2011 11:49:40 -0700

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix many (randconfig) PPP build errors by fixing typos in
> drivers/net/Makefile.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

I'll apply this, thanks Randy!
