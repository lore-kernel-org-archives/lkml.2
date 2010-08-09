Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0HIK16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:27:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48882
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119Ab0HIK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:27:49 -0400
Date: Mon, 09 Aug 2010 03:28:09 -0700 (PDT)
Message-Id: <20100809.032809.71101140.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a few minor changes:

1) Warning fix in tx493xide from Atsushi Nemoto.

2) Request completion fix in ide-cd driver from Borislav Petkov

3) memdup_user conversion from Julia Lawall

4) Fix typo in VT6415 device table entry, from Yann Dirson

Please pull, thanks a lot!

The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2010-08-08 10:10:11 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Atsushi Nemoto (1):
      tx493xide: use min_t() macro instead of min()

Borislav Petkov (1):
      ide-cd: Do not access completed requests in the irq handler

Julia Lawall (1):
      drivers/ide: Use memdup_user

Yann Dirson (1):
      via82cxxx: fix typo for VT6415 PCIE PATA IDE Host Controller support.

 drivers/ide/ide-cd.c       |   14 +++++++++++---
 drivers/ide/ide-taskfile.c |   10 +++-------
 drivers/ide/tx4938ide.c    |    2 +-
 drivers/ide/tx4939ide.c    |    2 +-
 drivers/ide/via82cxxx.c    |    2 +-
 5 files changed, 17 insertions(+), 13 deletions(-)
