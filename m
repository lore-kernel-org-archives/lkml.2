Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1IESbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 14:31:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39936 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1IESbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:31:10 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 0/5] ideapad: patches for v3.2 kernel
Date: Tue,  6 Sep 2011 02:31:07 +0800
Message-Id: <1315247467-8812-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No function changed with first two patches.

Adding event for Novo key, two nodes in debugfs and removing cfg
from sysfs.

Ike Panhc (5):
  ideapad: define vpc commands
  ideapad: change parameter of ideapad_sync_rfk_state
  ideapad: add event for Novo key
  ideapad: add debugfs support
  ideapad: remove sysfs node for cfg

 Documentation/ABI/testing/debugfs-ideapad          |   19 ++
 .../ABI/testing/sysfs-platform-ideapad-laptop      |   15 --
 drivers/platform/x86/ideapad-laptop.c              |  249 +++++++++++++++++---
 3 files changed, 234 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-ideapad

-- 
1.7.5.4

