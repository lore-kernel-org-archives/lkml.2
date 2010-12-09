Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab0LIClb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:41:31 -0500
Received: from mail.asbjorn.biz ([217.195.185.3]:56818 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0LICla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:41:30 -0500
From: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] e1000e: cleanup
Date: Thu,  9 Dec 2010 02:40:50 +0000
Message-Id: <1291862457-16671-1-git-send-email-asbjorn@asbjorn.biz>
X-Mailer: git-send-email 1.7.2.3
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset fixes most checkstyle problems in e1000e.

Checkpatch summary:
pre:	total:	221 errors,	129 warnings,	24520 lines checked
post:	total:	2 errors,	34 warnings,	24533 lines checked

The two remaining errors are of the type "Macros with complex values
should be enclosed in parenthesis", with macros containing 3 comma
seperated values.

The remaining warnings are all caused by <20ms msleep usage, that should
be replaced with usleep_range calls.

This patchset is based on top of jkirsher/net-next-2.6.git (67d5288)

Asbjoern Sloth Toennesen (7):
  e1000e: cleanup: fix spacing issues
  e1000e: cleanup: fix bracket issues
  e1000e: cleanup: simplify E1000_ALL_* defines
  e1000e: cleanup: fix long lines
  e1000e: cleanup: fix space issues in ich8_* structs
  e1000e: cleanup: swap arguments to avoid checkpatch errors
  e1000e: cleanup: fix copyright notices to preferred style

 drivers/net/e1000e/82571.c   |   70 +++++++-------
 drivers/net/e1000e/defines.h |  110 ++++++++++++-----------
 drivers/net/e1000e/e1000.h   |   93 +++++++++++---------
 drivers/net/e1000e/es2lan.c  |  135 ++++++++++++++--------------
 drivers/net/e1000e/ethtool.c |   75 ++++++++--------
 drivers/net/e1000e/hw.h      |   56 ++++++------
 drivers/net/e1000e/ich8lan.c |  185 +++++++++++++++++++-------------------
 drivers/net/e1000e/lib.c     |   78 ++++++++--------
 drivers/net/e1000e/netdev.c  |  171 +++++++++++++++++------------------
 drivers/net/e1000e/param.c   |   60 +++++++------
 drivers/net/e1000e/phy.c     |  204 +++++++++++++++++++++---------------------
 11 files changed, 625 insertions(+), 612 deletions(-)

-- 
1.7.2.3

