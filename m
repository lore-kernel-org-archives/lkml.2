Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702Ab2DKQgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:36:35 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44328 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760660Ab2DKQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:36:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v5 2/5] tools: Cleanup EXTRA_WARNINGS
Date: Wed, 11 Apr 2012 18:36:15 +0200
Message-Id: <1334162178-17152-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1334162178-17152-1-git-send-email-bp@amd64.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Use += instead of the bash syntax, as Sam Ravnborg suggests. Also, sort
the -W options alphabetically and (... keep them sorted).

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/scripts/Makefile.include |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 52348d3bd8d3..87b55a729a5f 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -11,26 +11,26 @@ endif
 #
 # Include saner warnings here, which can catch bugs:
 #
-EXTRA_WARNINGS := -Wformat
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wnested-externs
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
+EXTRA_WARNINGS := -Wbad-function-cast
+EXTRA_WARNINGS += -Wdeclaration-after-statement
+EXTRA_WARNINGS += -Wformat-security
+EXTRA_WARNINGS += -Wformat-y2k
+EXTRA_WARNINGS += -Winit-self
+EXTRA_WARNINGS += -Wmissing-declarations
+EXTRA_WARNINGS += -Wmissing-prototypes
+EXTRA_WARNINGS += -Wnested-externs
+EXTRA_WARNINGS += -Wno-system-headers
+EXTRA_WARNINGS += -Wold-style-definition
+EXTRA_WARNINGS += -Wpacked
+EXTRA_WARNINGS += -Wredundant-decls
+EXTRA_WARNINGS += -Wshadow
+EXTRA_WARNINGS += -Wstrict-aliasing=3
+EXTRA_WARNINGS += -Wstrict-prototypes
+EXTRA_WARNINGS += -Wswitch-default
+EXTRA_WARNINGS += -Wswitch-enum
+EXTRA_WARNINGS += -Wundef
+EXTRA_WARNINGS += -Wwrite-strings
+EXTRA_WARNINGS += -Wformat
 
 ifneq ($(findstring $(MAKEFLAGS), w),w)
 PRINT_DIR = --no-print-directory
-- 
1.7.9.3.362.g71319

