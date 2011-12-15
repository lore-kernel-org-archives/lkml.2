Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab1LOQ72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:59:28 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42287 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193Ab1LOQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:59:26 -0500
Date: Thu, 15 Dec 2011 11:57:10 -0500 (EST)
Message-Id: <20111215.115710.19471540928319216.davem@davemloft.net>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, cgroups@vger.kernel.org,
        eric.dumazet@gmail.com, sfr@canb.auug.org.au
Subject: Re: [PATCH 2/2] Explicitly call tcp creation and init from
 memcontrol.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111216011316.8d58bc8f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1323941672-14324-1-git-send-email-glommer@parallels.com>
	<1323941672-14324-3-git-send-email-glommer@parallels.com>
	<20111216011316.8d58bc8f.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Dec 2011 08:57:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 16 Dec 2011 01:13:16 +0900

> Could you remake the patch onto the 'latest' linux-next ?
> As Dave mentioned, some bandaids are already applied and this patch hunks.

He was correct to submit this against net-next.

The bandaid in linux-next is temporary and Stephen will remove it
once we fix things properly in net-next.
