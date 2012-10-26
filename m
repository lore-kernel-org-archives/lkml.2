Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab2JZOdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:33:00 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:34696 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab2JZOc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:57 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] frv: Remove unused is_in_rom()
Date: Fri, 26 Oct 2012 16:32:55 +0200
Message-Id: <1351261975-23522-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.5.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.10.26.142120
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_800_899 0, RDNS_NXDOMAIN 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is not used anywhere in the whole tree (anymore), so remove
it.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 arch/frv/include/asm/sections.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/frv/include/asm/sections.h b/arch/frv/include/asm/sections.h
index 17d0fb1..d03fb64 100644
--- a/arch/frv/include/asm/sections.h
+++ b/arch/frv/include/asm/sections.h
@@ -35,12 +35,6 @@ extern unsigned long __nongprelbss memory_start;
 extern unsigned long __nongprelbss memory_end;
 extern unsigned long __nongprelbss rom_length;
 
-/* determine if we're running from ROM */
-static inline int is_in_rom(unsigned long addr)
-{
-	return 0; /* default case: not in ROM */
-}
-
 #endif
 #endif
 #endif /* _ASM_SECTIONS_H */
-- 
1.7.5.4

