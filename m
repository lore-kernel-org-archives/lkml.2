Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2C2M0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:26:35 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60802 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058Ab2C2M0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:26:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/4] tools: Add a help target
Date: Thu, 29 Mar 2012 14:25:56 +0200
Message-Id: <1333023957-22746-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1333023957-22746-1-git-send-email-bp@amd64.org>
References: <1333023957-22746-1-git-send-email-bp@amd64.org>
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
index 134b3604b0b3..25566cd74937 100644
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
+	@echo '  perf       - Linux performance measurement and analysis tool'
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

