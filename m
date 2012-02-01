Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2BATWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:22:16 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33483 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2BATWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:22:12 -0500
Date: Wed, 01 Feb 2012 14:22:08 -0500 (EST)
Message-Id: <20120201.142208.1925500569694245125.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] netpoll: Convert printks to np_<level>
 and add pr_fmt
From: David Miller <davem@davemloft.net>
In-Reply-To: <8a61df72a4eb6caaeaa8b5be644be227da61512b.1327888082.git.joe@perches.com>
References: <8a61df72a4eb6caaeaa8b5be644be227da61512b.1327888082.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:22:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 29 Jan 2012 17:50:43 -0800

> Use a more current message logging style.
> Add pr_fmt to prefix dmesg output with "netpoll: "
> Add macros to print np->name.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
