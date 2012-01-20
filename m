Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2ATTRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 14:17:13 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:32966 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2ATTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 14:17:10 -0500
Date: Fri, 20 Jan 2012 14:14:46 -0500 (EST)
Message-Id: <20120120.141446.136970067758991080.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 1/3] net: fix socket memcg build with !CONFIG_NET
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327071436-20763-2-git-send-email-glommer@parallels.com>
References: <1327071436-20763-1-git-send-email-glommer@parallels.com>
	<1327071436-20763-2-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 20 Jan 2012 11:17:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 20 Jan 2012 18:57:14 +0400

> There is still a build bug with the sock memcg code, that triggers
> with !CONFIG_NET, that survived my series of randconfig builds.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>

Why are you undoing the static branch optimization?  That was a one of
the things that made me agree to even putting this code in.

Find a way to fix this without removing the static branch.

