Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab2DWE1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 00:27:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52522 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2DWE13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:27:29 -0400
Date: Mon, 23 Apr 2012 00:25:20 -0400 (EDT)
Message-Id: <20120423.002520.995859309070448490.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120423121451.c88c9bfaaf4d79313f7219f3@canb.auug.org.au>
References: <20120423121451.c88c9bfaaf4d79313f7219f3@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 Apr 2012 21:25:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 23 Apr 2012 12:14:51 +1000

> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> net/ax25/af_ax25.c: In function 'ax25_exit':
> net/ax25/af_ax25.c:2015:2: error: implicit declaration of function 'ax25_unregister_sysctl' [-Werror=implicit-function-declaration]
> 
> Caused by a mismerge between commit 3adadc08cc1e ("net ax25: Reorder
> ax25_exit to remove races") from the net tree and commit 0ca7a4c87d27
> ("net ax25: Simplify and cleanup the ax25 sysctl handling") from the
> net-next tree.
> 
> I have applied the following merge fix patch:

Looks correct, and I'll resolve this the next time I pull
net into net-next.

Thanks!
