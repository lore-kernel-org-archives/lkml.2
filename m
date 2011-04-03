Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1DCXIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:08:40 -0400
Received: from borg.medozas.de ([188.40.89.202]:52874 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1DCXIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:08:39 -0400
Date: Mon, 4 Apr 2011 01:08:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tony.luck@intel.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: pstore: fix "persistant" typo
Message-ID: <alpine.LNX.2.01.1104040107500.19073@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parent 78fca1b95837a44983608302e89c7258981be9b3 (v2.6.39-rc1-184-g78fca1b9)
commit 9e7e37e88264e35f3ba6d0dc1da8dd95e70f2b3f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Apr 4 01:07:41 2011 +0200

pstore: fix "persistant" typo

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 fs/pstore/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index 867d0ac..8007ae7 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -1,5 +1,5 @@
 config PSTORE
-	bool "Persistant store support"
+	bool "Persistent store support"
 	default n
 	help
 	   This option enables generic access to platform level
-- 
# Created with git-export-patch

