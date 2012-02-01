Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2BATWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:22:24 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33488 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273Ab2BATWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:22:21 -0500
Date: Wed, 01 Feb 2012 14:22:16 -0500 (EST)
Message-Id: <20120201.142216.1879481049733894828.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] netpoll: Neaten MAX_SKB_SIZE macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <c3a95a1d04d11f3741114ca206d37aea5609e504.1327888082.git.joe@perches.com>
References: <8a61df72a4eb6caaeaa8b5be644be227da61512b.1327888082.git.joe@perches.com>
	<c3a95a1d04d11f3741114ca206d37aea5609e504.1327888082.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:22:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 29 Jan 2012 17:50:44 -0800

> Add the types in the packet layout order.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
