Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab2FOWm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:42:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51916 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2FOWm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:42:56 -0400
Date: Fri, 15 Jun 2012 15:42:55 -0700 (PDT)
Message-Id: <20120615.154255.1670197217275981715.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Two fixes to icside, one for a build failure and another for
   a warning.  From Christian Dietrich.

2) Fix a bit operation that did erroneous masking, from Julia
   Lawall.

Please pull, thanks a lot!

The following changes since commit eea5b5510fc5545d15b69da8e485a7424ae388cf:

  Merge tag 'please-pull-mce' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras (2012-06-05 15:15:04 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to e58c5de8f59d124907c993ea3126c69493b7eec7:

  drivers/ide/ide-cs.c: adjust suspicious bit operation (2012-06-12 15:51:41 -0700)

----------------------------------------------------------------
Christian Dietrich (2):
      ide: icside.c: Fix compile with CONFIG_BLK_DEV_IDEDMA_ICS=n
      ide: icside.c: fix printk format string compile warning

Julia Lawall (1):
      drivers/ide/ide-cs.c: adjust suspicious bit operation

 drivers/ide/icside.c |   17 ++++++++---------
 drivers/ide/ide-cs.c |    3 ++-
 2 files changed, 10 insertions(+), 10 deletions(-)
