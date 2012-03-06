Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab2CFTb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:31:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39181 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758813Ab2CFTbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:31:25 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkpatch: whitespace - add/remove blank lines
Date: Tue,  6 Mar 2012 11:31:11 -0800
Message-Id: <e80d5e39da8b32e4818e11abfcd325572e279434.1331061916.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1331057839.2140.12.camel@joe2Laptop>
References: <1331057839.2140.12.camel@joe2Laptop>
In-Reply-To: <f027ae6deb2d02819f754ae9d45f54507a2d63f2.1331061916.git.joe@perches.com>
References: <f027ae6deb2d02819f754ae9d45f54507a2d63f2.1331061916.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add blank lines between a few tests, remove an extraneous one.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 135cb8f..19dcfe2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3354,18 +3354,20 @@ sub process {
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
 			     "consider using a completion\n" . $herecurr);
-
 		}
+
 # recommend kstrto* over simple_strto* and strict_strto*
 		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\(/) {
 			WARN("CONSIDER_KSTRTO",
 			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
 		}
+
 # check for __initcall(), use device_initcall() explicitly please
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("USE_DEVICE_INITCALL",
 			     "please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
+
 # check for various ops structs, ensure they are const.
 		my $struct_ops = qr{acpi_dock_ops|
 				address_space_operations|
-- 
1.7.8.111.gad25c.dirty

