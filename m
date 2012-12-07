Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2LGWm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:42:56 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64808 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2LGWmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:42:55 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] arch/x86/tools/gen-insn-attr-x86.awk: remove duplicate const
Date: Fri,  7 Dec 2012 22:42:27 +0000
Message-Id: <1354920151-4461-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/x86/tools/gen-insn-attr-x86.awk |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index ddcf39b..d1d9cfa 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -356,7 +356,7 @@ END {
 		exit 1
 	# print escape opcode map's array
 	print "/* Escape opcode map array */"
-	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \
+	print "const insn_attr_t *inat_escape_tables[INAT_ESC_MAX + 1]" \
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < geid; i++)
 		for (j = 0; j < max_lprefix; j++)
@@ -365,7 +365,7 @@ END {
 	print "};\n"
 	# print group opcode map's array
 	print "/* Group opcode map array */"
-	print "const insn_attr_t const *inat_group_tables[INAT_GRP_MAX + 1]"\
+	print "const insn_attr_t *inat_group_tables[INAT_GRP_MAX + 1]"\
 	      "[INAT_LSTPFX_MAX + 1] = {"
 	for (i = 0; i < ggid; i++)
 		for (j = 0; j < max_lprefix; j++)
-- 
1.7.4.5

