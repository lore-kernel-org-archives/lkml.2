Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab0LNFHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 00:07:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:47507 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0LNFHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 00:07:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb/kdb tree for 2.6.37-rc5
Date: Mon, 13 Dec 2010 23:04:51 -0600
Message-Id: <1292303092-32677-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 14 Dec 2010 05:06:57.0332 (UTC) FILETIME=[BB5B1740:01CB9B4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch to pick up a crash regression
fix for a regression introduced earlying the -rc cycle.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Thanks,
Jason.

---
The following changes since commit e8a7e48bb248a1196484d3f8afa53bded2b24e71:
  Linus Torvalds (1):
        Linux 2.6.37-rc4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (1):
      kgdboc,input: Fix regression with keyboard release key and early debugging

 drivers/serial/kgdboc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
