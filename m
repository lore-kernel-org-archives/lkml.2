Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab2DKQhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:37:15 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44346 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670Ab2DKQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:36:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v5 4/5] tools: Add a help target
Date: Wed, 11 Apr 2012 18:36:17 +0200
Message-Id: <1334162178-17152-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1334162178-17152-1-git-send-email-bp@amd64.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... and make it the default one so that calling 'make' without arguments
in the tools/ directory gives you the possible targets to build along
with a short description of what they are.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/Makefile b/tools/Makefile
index feadfdd6da55..f87c0ec63e6c 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -1,5 +1,25 @@
 include scripts/Makefile.include
 
+help:
+	@echo 'Possible targets:'
+	@echo ''
+	@echo '  cpupower   - a tool for all things x86 CPU power'
+	@echo '  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer'
+	@echo '  lguest     - a minimal 32-bit x86 hypervisor'
+	@echo '  perf       - Linux performance measurement and analysis tool'
+	@echo '  selftests  - various kernel selftests'
+	@echo '  turbostat  - Intel CPU idle stats and freq reporting tool'
+	@echo '  usb        - USB testing tools'
+	@echo '  virtio     - vhost test module'
+	@echo '  vm         - misc vm tools'
+	@echo '  x86_energy_perf_policy - Intel energy policy tool'
+	@echo ''
+	@echo 'Cleaning targets:'
+	@echo ''
+	@echo '  all of the above with the "_clean" string appended cleans'
+	@echo '    the respective build directory.'
+	@echo '  clean: a summary clean target to clean _all_ folders'
+
 cpupower: FORCE
 	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
 
-- 
1.7.9.3.362.g71319

