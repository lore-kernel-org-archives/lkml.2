Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350Ab2CAW0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:26:36 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965243Ab2CAW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:26:34 -0500
Date: Thu, 01 Mar 2012 17:24:27 -0500 (EST)
Message-Id: <20120301.172427.782491081561180393.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcarlson@broadcom.com,
        mchan@broadcom.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120301133333.b8297fbd964c1d7aaf8c9f0b@canb.auug.org.au>
References: <20120301133333.b8297fbd964c1d7aaf8c9f0b@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Mar 2012 14:24:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 1 Mar 2012 13:33:33 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/broadcom/tg3.c between commit 65ec698d1368 ("tg3:
> Fix tg3_get_stats64 for 5700 / 5701 devs") from the net tree and various
> commits from the net-next tree.
> 
> I just used the version from the net-next tree for today (assuming that
> this conflict will be fixed shortly).

I'll try to take care of this now, thanks Stephen.
