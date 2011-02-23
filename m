Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1BWFnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:43:18 -0500
Received: from mail.perches.com ([173.55.12.10]:3858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1BWFmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 15/18] MAINTAINERS: Update SFI pattern
Date: Tue, 22 Feb 2011 21:42:08 -0800
Message-Id: <efc86c2b8a8f10448e3da5e72cef545df0ed304f.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 937f961a6539b0ac5ebf31472b90810bc1f02200
("x86: Move sfi to platform")
moved the files, update the pattern.

cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 862e251..744fd30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5620,7 +5620,7 @@ L:	sfi-devel@simplefirmware.org
 W:	http://simplefirmware.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
 S:	Supported
-F:	arch/x86/kernel/*sfi*
+F:	arch/x86/platform/sfi/
 F:	drivers/sfi/
 F:	include/linux/sfi*.h
 
-- 
1.7.4.rc3

