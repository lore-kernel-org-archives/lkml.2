Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab2DKVIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:08:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761274Ab2DKVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:05:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/13] tools: Add a help target
Date: Wed, 11 Apr 2012 18:05:17 -0300
Message-Id: <1334178325-19148-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334178325-19148-1-git-send-email-acme@infradead.org>
References: <1334178325-19148-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... and make it the default one so that calling 'make' without arguments
in the tools/ directory gives you the possible targets to build along
with a short description of what they are.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-5-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/Makefile b/tools/Makefile
index feadfdd..f87c0ec 100644
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
1.7.9.2.358.g22243

