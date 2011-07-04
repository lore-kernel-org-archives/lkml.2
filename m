Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1GDDCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 23:02:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43461 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1GDDCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 23:02:30 -0400
Date: Sun, 03 Jul 2011 20:02:24 -0700 (PDT)
Message-Id: <20110703.200224.1596548736594048749.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, amwang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] netpoll: Remove unused EXPORT_SYMBOLs of
 netpoll_poll and netpoll_poll_dev
From: David Miller <davem@davemloft.net>
In-Reply-To: <282ce7d68b97c4dbfb759c1c0752e6cbddfeeafc.1309482314.git.joe@perches.com>
References: <cover.1309482314.git.joe@perches.com>
	<282ce7d68b97c4dbfb759c1c0752e6cbddfeeafc.1309482314.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 03 Jul 2011 20:02:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 30 Jun 2011 18:08:57 -0700

> Unused symbols waste space.
> 
> Commit 0e34e93177fb
> "(netpoll: add generic support for bridge and bonding devices)"
> added the symbol more than a year ago with the promise of "future use".
> 
> Because it is so far unused, remove it for now.
> It can be easily readded if or when it actually needs to be used.
> 
> cc: WANG Cong <amwang@redhat.com>
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
