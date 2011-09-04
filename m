Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1IDK0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:26:17 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36226 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab1IDK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:11 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: [PATCH 00/12] staging: et131x: Following mvoe to use phydev, remove detritus 
Date: Sun,  4 Sep 2011 11:24:31 +0100
Message-Id: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes make a big cleanup of the PHY driver code, and removing stuff that isn't (hopefully) relevant anymore.  

Mark Einon (12):
staging: et131x: Remove private adapter->linkspeed and
staging: et131x: Remove private adapter->duplex_mode
staging: et131x: Remove redundant struct adapter
staging: et131x: Remove PHY interrupt handling code
staging: et131x: remove calls to
staging: et131x: Remove registry_rx_mem_end from
staging: et131x: Remove cached_mask_value from
staging: et131x: Remove duplicated register defines
staging: et131x: Replace magic numbers in et1310_phy.c
staging: et131x: Remove struct mi_regs from
staging: et131x: Remove ai_force_[duplex|speed] from
staging: et131x: Update README file

 drivers/staging/et131x/README           |    2 -
 drivers/staging/et131x/et1310_mac.c     |   15 ++-
 drivers/staging/et131x/et1310_phy.c     |  105 ++++++++++-------------
 drivers/staging/et131x/et1310_phy.h     |  143 +++++++++++++++----------------
 drivers/staging/et131x/et1310_rx.c      |    9 ++-
 drivers/staging/et131x/et1310_tx.c      |    6 +-
 drivers/staging/et131x/et131x_adapter.h |   13 ---
 drivers/staging/et131x/et131x_initpci.c |   16 ++--
 drivers/staging/et131x/et131x_isr.c     |   40 ---------
 9 files changed, 143 insertions(+), 206 deletions(-)

