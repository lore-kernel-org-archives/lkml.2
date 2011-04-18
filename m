Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1DRDgC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 23:36:02 -0400
Received: from mail.perches.com ([173.55.12.10]:4788 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1DRDf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 23:35:57 -0400
From: Joe Perches <joe@perches.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] drm: Message logging cleanups
Date: Sun, 17 Apr 2011 20:35:50 -0700
Message-Id: <cover.1303097621.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the text space required and verify debug arguments.

Joe Perches (2):
  drm: Create and use drm_err
  drm: Verify debug message arguments

 drivers/gpu/drm/drm_irq.c               |    9 +++++----
 drivers/gpu/drm/drm_stub.c              |   21 +++++++++++++++++++++
 drivers/gpu/drm/i915/intel_bios.c       |    6 +++---
 drivers/gpu/drm/i915/intel_display.c    |    8 ++++----
 drivers/gpu/drm/radeon/radeon_display.c |    5 +++--
 include/drm/drmP.h                      |   24 +++++++++---------------
 6 files changed, 45 insertions(+), 28 deletions(-)

-- 
1.7.4.2.g597a6.dirty

