Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0LLSQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:16:44 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:42874
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752410Ab0LLSQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:16:43 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 0/3] Staging: rt2860: Fix checkpatch issues
Date: Sun, 12 Dec 2010 18:56:28 +0100
Message-Id: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the rt2860 is a widely used device (eeepc 901 for example), I think that
it would be nice to clean it up a little bit until the modern rt2x00 driver
supports reliabily the hardware.

This is the first set of patches to fix most trivial checkpatch issues.

Please note that I have chosen the KERN_* leves under my personal view. Comments
are welcome.

All patches compile-tested.

L. Alberto Giménez (3):
  Staging: rt2860: Clean spaces before tabs
  Staging: rt2860: Avoid extern in .c file
  Staging: rt2860: include KERN_* in printk

 drivers/staging/rt2860/common/ee_efuse.c |    6 ++--
 drivers/staging/rt2860/oid.h             |    2 +-
 drivers/staging/rt2860/pci_main_dev.c    |    5 +---
 drivers/staging/rt2860/rt_linux.c        |   21 +++++++++----------
 drivers/staging/rt2860/rt_linux.h        |    2 +-
 drivers/staging/rt2860/rt_main_dev.c     |    2 +-
 drivers/staging/rt2860/rt_usb.c          |   32 +++++++++++++++---------------
 drivers/staging/rt2860/usb_main_dev.c    |   12 +++++-----
 8 files changed, 39 insertions(+), 43 deletions(-)

-- 
1.7.2.3

