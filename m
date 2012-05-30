Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2E3U0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:26:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46257 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754310Ab2E3U0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:26:03 -0400
From: Joe Perches <joe@perches.com>
To: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] treewide: Fix likely misuses of | for &
Date: Wed, 30 May 2012 13:25:53 -0700
Message-Id: <cover.1338408931.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| with a non-zero constant is always true.
Likely these should have been &.

Joe Perches (4):
  mac80211: Fix likely misuse of | for &
  can: cc770: Fix likely misuse of | for &
  brcmfmac: Fix likely misuse of | for &
  usb: gadget: pch_udc: Fix likely misuse of | for &

 drivers/net/can/cc770/cc770_platform.c           |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    4 ++--
 drivers/usb/gadget/pch_udc.c                     |    2 +-
 net/mac80211/cfg.c                               |    6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
1.7.8.111.gad25c.dirty

