Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2GJCiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:38:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33351 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2GJCiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:38:14 -0400
Date: Mon, 09 Jul 2012 19:37:56 -0700 (PDT)
Message-Id: <20120709.193756.807327669543104730.davem@davemloft.net>
To: gaofeng@cn.fujitsu.com
Cc: eric.dumazet@gmail.com, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lizefan@huawei.com, tj@kernel.org
Subject: Re: [PATCH] net: cgroup: fix out of bounds accesses
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FFB9473.4040203@cn.fujitsu.com>
References: <4FFA9321.4030407@cn.fujitsu.com>
	<20120709.145125.1903343847210013668.davem@davemloft.net>
	<4FFB9473.4040203@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gao feng <gaofeng@cn.fujitsu.com>
Date: Tue, 10 Jul 2012 10:33:23 +0800

> Please see my patch in this thread, I think it's a better way to fix this bug.

You'll need to work that out with Eric, fwiw I think his patch was
clean and just fine and it's staying in my tree.
