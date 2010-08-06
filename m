Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935154Ab0HFUoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:44:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:43668 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935115Ab0HFUoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:44:46 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [GIT PULL] kgdboc compile fix
Date: Fri,  6 Aug 2010 15:43:41 -0500
Message-Id: <1281127422-15689-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 06 Aug 2010 20:44:26.0542 (UTC) FILETIME=[28CBE4E0:01CB35A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus which contains a compilation fix for
building without the kernel config option CONFIG_HW_CONSOLE.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_lin
us

There are some other fixes brewing, but this is the only known
compilation problem and I know we would like to keep the tree fully
bisectable.

Thanks,
Jason.

---
Jason Wessel (1):
      console: Fix compilation regression

 include/linux/console.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
