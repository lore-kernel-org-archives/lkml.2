Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1CXFK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:10:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45535 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1CXFK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:10:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 0/4] Blackfin updates for 2.6.39-rc0 (part two)
Date: Thu, 24 Mar 2011 01:10:56 -0400
Message-Id: <1300943456-19840-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more random fixes, some of which we've had laying around for
too long.  And yet another new syscall that needs to be wired up.

Graf Yang (1):
  Blackfin: SMP: flush CoreB cache when shutting down

Mike Frysinger (3):
  Blackfin: wire up new syncfs syscall
  Blackfin: enable atomic64_t support
  Blackfin: bf54x: re-enable anomaly 05000353 for all revs

 arch/blackfin/Kconfig                           |    1 +
 arch/blackfin/include/asm/atomic.h              |    2 ++
 arch/blackfin/include/asm/unistd.h              |    3 ++-
 arch/blackfin/mach-bf548/include/mach/anomaly.h |    6 +++++-
 arch/blackfin/mach-bf561/hotplug.c              |    9 +++++++++
 arch/blackfin/mach-common/entry.S               |    1 +
 6 files changed, 20 insertions(+), 2 deletions(-)

-- 
1.7.4.1

