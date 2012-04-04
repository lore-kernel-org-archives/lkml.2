Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2DDJZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 05:25:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43756 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab2DDJZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 05:25:17 -0400
Date: Wed, 04 Apr 2012 05:25:05 -0400 (EDT)
Message-Id: <20120404.052505.230288445505560474.davem@davemloft.net>
To: slash@ac.auone-net.jp
Cc: netdev@vger.kernel.org, xemul@parallels.com, linux-kernel@vger.kernel.org
Subject: Re: Commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 has broken ss
 command
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
References: <20120404090312.1B68C6AC03E@msa102.auone-net.jp>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 02:25:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kusanagi Kouichi <slash@ac.auone-net.jp>
Date: Wed, 4 Apr 2012 18:03:11 +0900

> Since commit 8ef874bfc7296fa206eea2ad1e8a426f576bf6f6 ("sock_diag:
> Move the sock_ code to net/core/"), ss command from iproute package
> doesn't work if INET_DIAG is not enabled.

Well, of course you need to enable that Kconfig options to get
netlink socket dumping support for inet protocols.
