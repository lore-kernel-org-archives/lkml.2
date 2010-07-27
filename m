Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0G0Xxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:53:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38910 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab0G0XwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:00 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 10/15] Fix a typo
Date: Tue, 27 Jul 2010 17:50:58 -0600
Message-Id: <1280274663-9160-11-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index cde31f9..fc3d6b5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -560,7 +560,7 @@ config HP_WATCHDOG
 	depends on X86
 	help
 	  A software monitoring watchdog and NMI sourcing driver. This driver
-	  will detect lockups and provide stack trace. Also, when an NMI
+	  will detect lockups and provide a stack trace. Also, when an NMI
 	  occurs this driver will make the necessary BIOS calls to log
 	  the cause of the NMI. This is a driver that will only load on a
 	  HP ProLiant system with a minimum of iLO2 support.
-- 
1.7.1

