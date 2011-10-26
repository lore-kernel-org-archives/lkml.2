Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1JZAca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 20:32:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35502 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1JZAc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 20:32:29 -0400
Date: Tue, 25 Oct 2011 20:32:20 -0400 (EDT)
Message-Id: <20111025.203220.473592143736213946.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 25 Oct 2011 17:32:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Three bug fixes here, including the sk_clone() error path unlock
fix from Thomas Gleixner.

As for the wireless warning spew, it is my understanding that person
most able to fix that bug is in the same room with you right now (hi
Johannes Berg :-)

Please pull, thanks a lot!

The following changes since commit 7670c7010c7b367ca40c3aba02afb36149764a6e:

  Merge branch 'for-linus' of git://github.com/gregungerer/m68knommu (2011-10-25 16:25:48 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

David Woodhouse (1):
      caif: Fix BUG() with network namespaces

Maciej ¯enczykowski (1):
      net: make bonding slaves honour master's skb->priority

Thomas Gleixner (1):
      net: Unlock sock before calling sk_free()

 drivers/net/bonding/bond_main.c |    1 -
 net/caif/caif_dev.c             |    5 +++--
 net/core/sock.c                 |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)
