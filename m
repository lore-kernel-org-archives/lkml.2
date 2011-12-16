Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab1LPUh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:37:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58472 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191Ab1LPUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:37:42 -0500
Date: Fri, 16 Dec 2011 15:35:34 -0500 (EST)
Message-Id: <20111216.153534.1737903298375474554.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH 2/2] net: fix compilation with !CONFIG_NET
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324032720-13752-2-git-send-email-glommer@parallels.com>
References: <1324032720-13752-1-git-send-email-glommer@parallels.com>
	<1324032720-13752-2-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Dec 2011 12:35:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri, 16 Dec 2011 14:52:00 +0400

> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Applied.
