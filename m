Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0G1UkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:40:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:62705 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab0G1UkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:40:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb regression fixes for 2.6.35-rc5
Date: Wed, 28 Jul 2010 15:39:49 -0500
Message-Id: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 28 Jul 2010 20:39:55.0126 (UTC) FILETIME=[094D5960:01CB2E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch for 2.6.35-rc6.  

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

The kgdb validation tests found a regression where HW breakpoints
stopped working with kdb / kgdb.  The problem was bisected and after
talking with Frederic Weisbecker a patch was generated to repair the
regression.

Thanks,
Jason.


---
Jason Wessel (1):
      x86,kgdb: Fix hw breakpoint regression

 arch/x86/kernel/kgdb.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)
