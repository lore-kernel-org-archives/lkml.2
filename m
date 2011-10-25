Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1JYRQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:16:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:9046 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1JYRQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:16:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="67280595"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] pstore changes
Date: Tue, 25 Oct 2011 10:16:49 -0700
Message-Id: <4ea6ef012397885b0@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git pstore
	HEAD=b238b8fa93353ab50c9a2b1e2fa47a0ab01c37cd

This will update the files shown below.

Thanks!

-Tony

 drivers/acpi/apei/erst.c   |   12 +++--
 drivers/firmware/efivars.c |   19 +++++----
 fs/pstore/inode.c          |   40 +++++++++++++++++--
 fs/pstore/internal.h       |    2 +-
 fs/pstore/platform.c       |   93 ++++++++++++++++++++++++++++++++++----------
 include/linux/pstore.h     |    6 +-
 6 files changed, 129 insertions(+), 43 deletions(-)

Chen Gong (1):
      pstore: make pstore write function return normal success/fail value

Don Zickus (1):
      pstore: change mutex locking to spin_locks

Tony Luck (1):
      pstore: defer inserting OOPS entries into pstore

