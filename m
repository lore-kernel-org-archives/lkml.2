Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2AJBBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:01:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42636 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJBBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:01:39 -0500
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] init/Kconfig: Fix dependency for SCHED_AUTOGROUP
Date: Mon,  9 Jan 2012 23:01:28 -0200
Message-Id: <1326157288-4407-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning:

warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 34f6d0c..b5cae89 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -850,6 +850,7 @@ endif # NAMESPACES
 
 config SCHED_AUTOGROUP
 	bool "Automatic process group scheduling"
+	depends on EXPERIMENTAL
 	select EVENTFD
 	select CGROUPS
 	select CGROUP_SCHED
-- 
1.7.1

