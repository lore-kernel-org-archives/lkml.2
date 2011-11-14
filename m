Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1KNFMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:12:20 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab1KNFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:12:18 -0500
Date: Mon, 14 Nov 2011 00:12:10 -0500 (EST)
Message-Id: <20111114.001210.728555642579535986.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: venkat.x.venkatsubra@oracle.com, rds-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rds: drop "select LLIST"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321191397.20271.62.camel@x61.thuisdomein>
References: <1321191397.20271.62.camel@x61.thuisdomein>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:12:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Sun, 13 Nov 2011 14:36:37 +0100

> Commit 1bc144b625 ("net, rds, Replace xlist in net/rds/xlist.h with
> llist") added "select LLIST" to the RDS_RDMA Kconfig entry. But there is
> no Kconfig symbol named LLIST. The select statement for that symbol is a
> nop. Drop it.
> 
> lib/llist.o is builtin, so all that's needed to use the llist
> functionality is to include linux/llist.h, which this commit also did.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied.
