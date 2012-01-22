Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2AVTZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:25:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:48992 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2AVTZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:25:35 -0500
Date: Sun, 22 Jan 2012 14:25:31 -0500 (EST)
Message-Id: <20120122.142531.1412329310002297019.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 9/14] kernel-doc: fix new warning in net/phy/mdio_bus.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F1B0BE8.9050403@xenotime.net>
References: <4F1B0BE8.9050403@xenotime.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 Jan 2012 11:25:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:04 -0800

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix new kernel-doc warning:
> 
> Warning(drivers/net/phy/mdio_bus.c:49): No description found for parameter 'size'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Applied.
