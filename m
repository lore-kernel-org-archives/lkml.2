Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1LNLtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:49:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51439 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1LNLtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:23 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 0/7] remoteproc/rpmsg: a few trivial fixes
Date: Wed, 14 Dec 2011 13:48:28 +0200
Message-Id: <1323863315-8159-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two fixes from Mark (required for controlling non-IOMMU and non-Virtio
remote processors via remoteproc), two fixes which were reported by
Stephen Boyd, and three other trivial cleanups.

Mark Grosen (2):
  remoteproc: do not require an iommu
  remoteproc: avoid registering a virtio device if not supported

Ohad Ben-Cohen (5):
  remoteproc: remove unused resource type
  remoteproc/omap: utilize module_platform_driver
  remoteproc: look for truncated firmware images
  remoteproc: add Kconfig menu
  rpmsg: add Kconfig menu

 drivers/remoteproc/Kconfig           |    4 +++
 drivers/remoteproc/omap_remoteproc.c |   13 +----------
 drivers/remoteproc/remoteproc_core.c |   41 +++++++++++++++++++++++++++------
 drivers/rpmsg/Kconfig                |    4 +++
 include/linux/remoteproc.h           |    1 -
 5 files changed, 42 insertions(+), 21 deletions(-)

-- 
1.7.5.4

