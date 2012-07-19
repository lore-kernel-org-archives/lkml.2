Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab2GSU3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:29:20 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:35715 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:29:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: x86@kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] trivial: spelling s/postition/position/g
Date: Thu, 19 Jul 2012 22:29:11 +0200
Message-Id: <1342729751-17947-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/module.c |    4 ++--
 arch/x86/kernel/module.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/module.c b/arch/m68k/kernel/module.c
index 34849c4..eb46fd6 100644
--- a/arch/m68k/kernel/module.c
+++ b/arch/m68k/kernel/module.c
@@ -47,7 +47,7 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 			*location += sym->st_value;
 			break;
 		case R_68K_PC32:
-			/* Add the value, subtract its postition */
+			/* Add the value, subtract its position */
 			*location += sym->st_value - (uint32_t)location;
 			break;
 		default:
@@ -87,7 +87,7 @@ int apply_relocate_add(Elf32_Shdr *sechdrs,
 			*location = rel[i].r_addend + sym->st_value;
 			break;
 		case R_68K_PC32:
-			/* Add the value, subtract its postition */
+			/* Add the value, subtract its position */
 			*location = rel[i].r_addend + sym->st_value - (uint32_t)location;
 			break;
 		default:
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index f21fd94..772e7ad 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -73,7 +73,7 @@ int apply_relocate(Elf32_Shdr *sechdrs,
 			*location += sym->st_value;
 			break;
 		case R_386_PC32:
-			/* Add the value, subtract its postition */
+			/* Add the value, subtract its position */
 			*location += sym->st_value - (uint32_t)location;
 			break;
 		default:
-- 
1.7.0.4

