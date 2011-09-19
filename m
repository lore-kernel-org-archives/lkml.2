Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab1ISDOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:14:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35817 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1ISDOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:14:02 -0400
Date: Sun, 18 Sep 2011 23:13:58 -0400 (EDT)
Message-Id: <20110918.231358.1701611368789467684.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 18 Sep 2011 20:14:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I fixed up Eric's build fix and also there is a fix for a
reversed test in TCP's DSACK validation from Zheng Yan.

Please pull, thanks a lot!

The following changes since commit b0e7031ac08fa0aa242531c8d9a0cf9ae8ee276d:

  Merge git://github.com/davem330/net (2011-09-18 11:02:26 -0700)

are available in the git repository at:

  git://github.com/davem330/net.git master

Eric Dumazet (1):
      tcp: fix build error if !CONFIG_SYN_COOKIES

Zheng Yan (1):
      tcp: fix validation of D-SACK

 include/net/tcp.h    |   19 ++++++++++++++++++-
 net/ipv4/tcp_input.c |    2 +-
 2 files changed, 19 insertions(+), 2 deletions(-)
