Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab1LOWq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:46:26 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45046 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759349Ab1LOWqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:46:25 -0500
Date: Thu, 15 Dec 2011 17:44:11 -0500 (EST)
Message-Id: <20111215.174411.213210944798851570.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        eric.dumazet@gmail.com, sfr@canb.auug.org.au
Subject: Re: [PATCH 2/2] Explicitly call tcp creation and init from
 memcontrol.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <4EEA6288.1080405@parallels.com>
References: <1323941672-14324-3-git-send-email-glommer@parallels.com>
	<20111215.120028.532844419499092747.davem@davemloft.net>
	<4EEA6288.1080405@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Dec 2011 14:44:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 16 Dec 2011 01:11:36 +0400

> How about the following patch then ? I am keeping protocols that has
> the cgroup stuff on in a separate list, that can be protected by a
> mutex. Therefore we can allocate without going into troubles.

This is a significantly better approach, please test and submit this
patch formally.

Thanks.
