Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab2DQDuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 23:50:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50684 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2DQDup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 23:50:45 -0400
Date: Mon, 16 Apr 2012 23:48:27 -0400 (EDT)
Message-Id: <20120416.234827.1041224459359020201.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hippi@sunsite.dk, jes@trained-monkey.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH -next] hippi: fix printk format in rrunner.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F8CC0ED.2000006@xenotime.net>
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
	<4F8CC0ED.2000006@xenotime.net>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 Apr 2012 20:48:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 16 Apr 2012 18:01:33 -0700

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix printk format warning (from i386 build):
> 
> drivers/net/hippi/rrunner.c:146:9: warning: format '%08llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

I'll apply this, thanks Randy.
