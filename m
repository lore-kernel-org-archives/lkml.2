Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab2CSAbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:31:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34465 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757313Ab2CSAbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:31:13 -0400
From: Joe Perches <joe@perches.com>
To: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        ath9k-devel@venema.h4ckr.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 0/3] ath: printk cleanups and code reduction
Date: Sun, 18 Mar 2012 17:30:51 -0700
Message-Id: <cover.1332116921.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  ath: Add and use pr_fmt, convert printks to pr_<level>
  ath5k: Introduce _ath5k_printk to reduce code/text
  ath6kl: Add __printf verification to ath6kl_printk

 drivers/net/wireless/ath/ath5k/ani.c          |   44 +++++++++++--------------
 drivers/net/wireless/ath/ath5k/ath5k.h        |   29 +++++++++-------
 drivers/net/wireless/ath/ath5k/attach.c       |    2 +
 drivers/net/wireless/ath/ath5k/base.c         |   22 ++++++++++++
 drivers/net/wireless/ath/ath5k/debug.c        |   17 ++++++----
 drivers/net/wireless/ath/ath5k/desc.c         |    2 +
 drivers/net/wireless/ath/ath5k/dma.c          |    2 +
 drivers/net/wireless/ath/ath5k/eeprom.c       |    2 +
 drivers/net/wireless/ath/ath5k/initvals.c     |    5 ++-
 drivers/net/wireless/ath/ath5k/led.c          |    2 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +
 drivers/net/wireless/ath/ath5k/pci.c          |    4 ++-
 drivers/net/wireless/ath/ath5k/phy.c          |    2 +
 drivers/net/wireless/ath/ath5k/qcu.c          |    2 +
 drivers/net/wireless/ath/ath5k/reset.c        |    2 +
 drivers/net/wireless/ath/ath5k/sysfs.c        |    2 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c    |    2 +
 drivers/net/wireless/ath/ath6kl/common.h      |    3 +-
 drivers/net/wireless/ath/ath6kl/init.c        |    2 +
 drivers/net/wireless/ath/ath6kl/main.c        |    2 +
 drivers/net/wireless/ath/ath6kl/txrx.c        |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    8 ++--
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    7 ++--
 drivers/net/wireless/ath/ath9k/init.c         |   13 +++----
 drivers/net/wireless/ath/ath9k/pci.c          |    9 +++--
 drivers/net/wireless/ath/main.c               |    4 ++-
 drivers/net/wireless/ath/regd.c               |    4 ++-
 27 files changed, 128 insertions(+), 69 deletions(-)

-- 
1.7.8.111.gad25c.dirty

