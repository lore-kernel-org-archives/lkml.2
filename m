Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1C3FLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:11:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41735 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1C3FLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:11:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Wed, 30 Mar 2011 01:11:04 -0400
Message-Id: <1301461864-19453-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301461742-19108-1-git-send-email-vapier@gentoo.org>
References: <1301461742-19108-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Joe Perches (1):
      Blackfin: use more standard pr_fmt in the module loader

Mike Frysinger (2):
      Blackfin: defconfigs: update after misc devices defaulted to N
      Blackfin: bitops: fix include order after little endian inclusion

 arch/blackfin/configs/BF527-AD7160-EVAL_defconfig |    1 -
 arch/blackfin/configs/BF538-EZKIT_defconfig       |    1 -
 arch/blackfin/configs/BF561-ACVILON_defconfig     |    1 -
 arch/blackfin/configs/BlackStamp_defconfig        |    1 +
 arch/blackfin/configs/CM-BF527_defconfig          |    1 -
 arch/blackfin/configs/CM-BF533_defconfig          |    1 -
 arch/blackfin/configs/CM-BF548_defconfig          |    1 -
 arch/blackfin/configs/DNP5370_defconfig           |    1 -
 arch/blackfin/configs/H8606_defconfig             |    1 +
 arch/blackfin/configs/SRV1_defconfig              |    1 +
 arch/blackfin/include/asm/bitops.h                |    4 +-
 arch/blackfin/kernel/module.c                     |   45 ++++++++------------
 12 files changed, 24 insertions(+), 35 deletions(-)
