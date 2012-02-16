Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2BPNPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:15:04 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:47402
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2BPNPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:15:01 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix typo in thin-provisioning.txt
Date: Thu, 16 Feb 2012 22:14:34 +0900
Message-Id: <1329398074-1597-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "descibes" to "describes" in
Documentation/device-mapper/thin-provisioning.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/device-mapper/thin-provisioning.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
index 801d9d1..1ff044d 100644
--- a/Documentation/device-mapper/thin-provisioning.txt
+++ b/Documentation/device-mapper/thin-provisioning.txt
@@ -1,7 +1,7 @@
 Introduction
 ============
 
-This document descibes a collection of device-mapper targets that
+This document describes a collection of device-mapper targets that
 between them implement thin-provisioning and snapshots.
 
 The main highlight of this implementation, compared to the previous
-- 
1.7.4.4

