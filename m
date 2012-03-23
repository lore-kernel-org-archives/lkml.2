Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab2CWOnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:43:18 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:52594 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab2CWOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:43:13 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/3] tools: Add a help target
Date: Fri, 23 Mar 2012 15:43:08 +0100
Message-Id: <1332513788-9726-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1332513788-9726-1-git-send-email-bp@amd64.org>
References: <1332513788-9726-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... and make it the default one so that calling 'make' without arguments
in the tools/ directory gives you the possible targets to build along
with a short description of what they are.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/Makefile b/tools/Makefile
index 134b3604b0b3..cd415b40c59d 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -1,5 +1,24 @@
 include scripts/Makefile.include
 
+help:
+	@echo 'Possible targets:'
+	@echo ''
+	@echo '  cpupower   - a tool for all things x86 CPU power'
+	@echo '  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer'
+	@echo '  lguest     - a minimal 32-bit x86 hypervisor'
+	@echo '  perf       - Linux performance measurements tool'
+	@echo '  slub       - slabs reporting tool'
+	@echo '  turbostat  - Intel CPU idle stats and freq reporting tool'
+	@echo '  usb        - USB testing tools'
+	@echo '  virtio     - vhost test module'
+	@echo '  x86_energy_perf_policy - Intel energy policy tool'
+	@echo ''
+	@echo 'Cleaning targets:'
+	@echo ''
+	@echo '  all of the above with the "_clean" string appended cleans'
+	@echo '    the respective build directory.'
+	@echo '  clean: a summary clean target to clean _all_ folders'
+
 perf firewire lguest slub usb virtio: FORCE
 	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
 
-- 
1.7.9.3.362.g71319

