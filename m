Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab2DPGSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:18:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41070 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2DPGSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:18:23 -0400
Date: Mon, 16 Apr 2012 02:16:13 -0400 (EDT)
Message-Id: <20120416.021613.606704342231219042.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, tkhai@yandex.ru,
        sam@ravnborg.org
Subject: Re: linux-next: build failure after merge of the final tree
 (sparc-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120416155907.32c0041caa002f72da4635b7@canb.auug.org.au>
References: <20120416155907.32c0041caa002f72da4635b7@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 15 Apr 2012 23:16:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 16 Apr 2012 15:59:07 +1000

> After merging the final tree, today's linux-next build (sparc32 defconfig)
> failed like this:
> 
> arch/sparc/kernel/pcic.c: In function 'pci_time_init':
> arch/sparc/kernel/pcic.c:741:2: error: 'timer_cs_period' undeclared (first use in this function)
> 
> Caused by commit 62f082830d63 ("sparc32: generic clockevent support").
> 
> I have reverted that commit for today.

Sam, Tkhai, please fix this.
