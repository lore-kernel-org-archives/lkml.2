Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab0HWIjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:39:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57196 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0HWIjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:39:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Blackfin updates for 2.6.36-rc2
Date: Mon, 23 Aug 2010 04:40:02 -0400
Message-Id: <1282552805-18989-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix breakage/warnings introduced by post 2.6.35 commits, and add
maintainers entries for ADI ASoC drivers.  Pretty straight forward.

Mike Frysinger (3):
  Blackfin: fix hweight breakage
  ADI/ASoC: add MAINTAINERS entries
  Blackfin: wire up new fanotify/prlimit64 syscalls

 MAINTAINERS                        |   11 +++++++++++
 arch/blackfin/include/asm/bitops.h |   17 ++++++++++-------
 arch/blackfin/include/asm/unistd.h |    5 ++++-
 arch/blackfin/mach-common/entry.S  |    3 +++
 4 files changed, 28 insertions(+), 8 deletions(-)

-- 
1.7.2

