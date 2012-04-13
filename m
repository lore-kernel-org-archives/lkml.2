Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2DMSQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:16:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2DMSQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:16:11 -0400
Date: Fri, 13 Apr 2012 11:15:33 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-d8caf3eb240f4b3100cd8e4f0178df9801bce537@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, sam@ravnborg.org, tglx@linutronix.de, mmarek@suse.cz,
        borislav.petkov@amd.com
In-Reply-To: <1334162178-17152-3-git-send-email-bp@amd64.org>
References: <1334162178-17152-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools: Cleanup EXTRA_WARNINGS
Git-Commit-ID: d8caf3eb240f4b3100cd8e4f0178df9801bce537
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:15:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8caf3eb240f4b3100cd8e4f0178df9801bce537
Gitweb:     http://git.kernel.org/tip/d8caf3eb240f4b3100cd8e4f0178df9801bce537
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 11 Apr 2012 18:36:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Apr 2012 14:57:50 -0300

tools: Cleanup EXTRA_WARNINGS

Use += instead of the bash syntax, as Sam Ravnborg suggests. Also, sort
the -W options alphabetically and (... keep them sorted).

Suggested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: http://lkml.kernel.org/r/1334162178-17152-3-git-send-email-bp@amd64.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/scripts/Makefile.include |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 52348d3..87b55a7 100644
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
