Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab1C3FJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:09:06 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41420 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1C3FJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:09:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 0/3] Blackfin fixes for 2.6.39-rc1
Date: Wed, 30 Mar 2011 01:09:02 -0400
Message-Id: <1301461742-19108-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A build fix for a recent merge, an update for defconfigs which broke due
to common Kconfig change, and a minor module loader tweak.  These latter
two have been hanging around for a while, but I forgot about them.

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

-- 
1.7.4.1

