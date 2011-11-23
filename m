Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab1KWA0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:26:05 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1KWA0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:26:03 -0500
Date: Tue, 22 Nov 2011 19:23:56 -0500 (EST)
Message-Id: <20111122.192356.1964321544725536133.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, maze@google.com, adobriyan@gmail.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111123111751.60b1e8ba032f6077fa03ca13@canb.auug.org.au>
References: <20111123111751.60b1e8ba032f6077fa03ca13@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 Nov 2011 16:23:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 Nov 2011 11:17:51 +1100

> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> net/ipv4/inet_diag.c between commit 717b6d836646 ("net-netlink: fix diag
> to export IPv4 tos for dual-stack IPv6 sockets") from the net tree and
> commit 4e3fd7a06dc2 ("net: remove ipv6_addr_copy()") from the net-next
> tree.
> 
> Just context changes.  I fixed it up (see below) can can carry the fix as
> necessary,

Yep, I anticipated this one too, thanks Stephen.
