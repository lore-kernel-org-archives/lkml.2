Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab2AOIjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 03:39:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51016 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750986Ab2AOIjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 03:39:03 -0500
From: Joe Perches <joe@perches.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] brcm80211: Logging cleanups
Date: Sun, 15 Jan 2012 00:38:37 -0800
Message-Id: <cover.1326616556.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (8):
  brcm80211: Use normal DEBUG define
  brcmfmac: Convert printk(KERN_DEBUG to pr_debug
  brcm80211: Add and use brcmX_dbg_dump_hex
  brcmfmac: Remove useless #ifdef DEBUG
  brcm80211: Convert printk(KERN_DEBUG to pr_debug
  brcm80211: Use brcmu_dbg_hex_dump
  brcm80211: Use pr_fmt and pr_<level>
  brcmfmac: Trivial typo of "couldn" to "could" fix

 drivers/net/wireless/brcm80211/Makefile            |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 +
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   17 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   20 ++-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  216 ++++++++------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    2 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   36 ++--
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |    8 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   24 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  194 ++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    6 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    5 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   26 ++-
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   15 ++-
 22 files changed, 298 insertions(+), 304 deletions(-)

-- 
1.7.8.111.gad25c.dirty

