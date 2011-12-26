Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1LZUTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 15:19:51 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1LZUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 15:19:49 -0500
Date: Mon, 26 Dec 2011 15:19:36 -0500 (EST)
Message-Id: <20111226.151936.1114579002330233726.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, yevgenyp@mellanox.co.il,
        jackm@dev.mellanox.co.il, marcela@dev.mellanox.co.il,
        eugenia@mellanox.co.il, netdev@vger.kernel.org
Subject: Re: [PATCH] mlx4: Add missing include of linux/slab.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324892134.9765.1.camel@phoenix>
References: <1324892134.9765.1.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Dec 2011 12:19:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 26 Dec 2011 17:35:34 +0800

> Include linux/slab.h to fix below build error:

You make no indication whatsoever what source tree you see this
error in.

By trial and error I figured out that your patch only applies to
the net-next tree, so I added it there.

But I should not have to go through such a sequence just to figure out
what tree your patch is for, so please indicate this properly in the
future.
