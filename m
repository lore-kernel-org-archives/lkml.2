Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2DSGmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:42:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45874 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2DSGmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:42:44 -0400
Date: Thu, 19 Apr 2012 02:40:34 -0400 (EDT)
Message-Id: <20120419.024034.1013342902483709669.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, majianpeng@gmail.com
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120419162859.904574e2518c5a904802efbc@canb.auug.org.au>
References: <20120419162859.904574e2518c5a904802efbc@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Apr 2012 23:40:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 19 Apr 2012 16:28:59 +1000

> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> net/ipv4/route.c: In function 'ip_static_sysctl_init':
> net/ipv4/route.c:3517:2: error: implicit declaration of function 'kmemleak_not_leak' [-Werror=implicit-function-declaration]
...
> net/core/sysctl_net_core.c: In function 'sysctl_core_init':
> net/core/sysctl_net_core.c:259:2: error: implicit declaration of function 'kmemleak_not_leak' [-Werror=implicit-function-declaration]
...

I already checked in a fix for this, thanks Stephen.
