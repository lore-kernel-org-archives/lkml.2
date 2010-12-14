Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab0LNA5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:57:12 -0500
Received: from mail.perches.com ([173.55.12.10]:2599 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758699Ab0LNA5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:11 -0500
From: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] staging: brcm80211: Cleanup include/proto/ethernet.h
Date: Mon, 13 Dec 2010 16:56:56 -0800
Message-Id: <cover.1292287720.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard kernel mechanisms and remove some entries from this file.

Joe Perches (8):
  staging: brcm80211: Remove unused #defines ETHER_<foo>_LOCALADDR
  staging: brcm80211: Convert ETHER_IS_MULTI to is_multicast_ether_addr
  staging: brcm80211: Remove unused ether_<foo> #defines and struct
  staging: brcm80211: Convert ETHER_IS<FOO> to is_<foo>_ether_addr
  staging: brcm80211: Convert ETHER_ADDR_LEN to ETH_ALEN
  staging: brcm80211: Remove ETHER_HDR_LEN, use ETH_HLEN
  staging: brcm80211: Remove unused ETHER_TYPE_<foo> #defines
  staging: brcm80211: Convert ETHER_TYPE_802_1X to ETH_P_PAE

 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   32 +++++-----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   38 ++++++------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   63 ++++++++++----------
 drivers/staging/brcm80211/include/proto/ethernet.h |   54 +++--------------
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    2 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |    9 ++-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   40 +++++++------
 drivers/staging/brcm80211/util/bcmsrom.c           |   15 +++--
 12 files changed, 118 insertions(+), 149 deletions(-)

-- 
1.7.3.3.398.g0b0cd.dirty

