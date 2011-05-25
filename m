Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab1EYRCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:02:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2004 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab1EYRCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:02:44 -0400
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, kvm-ia64@vger.kernel.org,
        kvm@vger.kernel.org, linux-ext4@vger.kernel.org,
        oprofile-list@lists.sf.net
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 0/4] printk: cleanups of direct includes
Date: Wed, 25 May 2011 10:02:37 -0700
Message-Id: <cover.1306342673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
References: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk.h is a subfile of kernel.h, do not allow it to
be included directly.

Joe Perches (4):
  treewide: Remove direct includes of printk.h
  staging: Remove direct includes of printk.h
  printk: Don't allow direct inclusion
  treewide: Remove asmlinkage from printk

 arch/arm/kernel/early_printk.c                |    2 +-
 arch/ia64/kvm/vmm.c                           |    2 +-
 arch/x86/kernel/early_printk.c                |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    1 -
 drivers/staging/brcm80211/util/bcmutils.c     |    1 -
 drivers/staging/usbip/usbip_common.h          |    2 +-
 fs/ext4/inode.c                               |    1 -
 include/linux/oprofile.h                      |    2 +-
 include/linux/printk.h                        |   10 +++++++---
 kernel/printk.c                               |    6 +++---
 kernel/sysctl.c                               |    3 +--
 11 files changed, 16 insertions(+), 16 deletions(-)

-- 
1.7.4.rc3

