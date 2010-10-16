Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab0JPVoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 17:44:08 -0400
Received: from [69.28.251.93] ([69.28.251.93]:33724 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab0JPVoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 17:44:06 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] MIPS: Add BMIPS CP0 register definitions
Date: Sat, 16 Oct 2010 14:22:32 -0700
Message-Id: <c6dd81d43765a1646f0d0d607df3bd20@localhost>
In-Reply-To: <17ebecce124618ddf83ec6fe8e526f93@localhost>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/mipsregs.h |   51 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 335474c..4d98709 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -1040,6 +1040,12 @@ do {									\
 #define read_c0_dtaglo()	__read_32bit_c0_register($28, 2)
 #define write_c0_dtaglo(val)	__write_32bit_c0_register($28, 2, val)
 
+#define read_c0_ddatalo()	__read_32bit_c0_register($28, 3)
+#define write_c0_ddatalo(val)	__write_32bit_c0_register($28, 3, val)
+
+#define read_c0_staglo()	__read_32bit_c0_register($28, 4)
+#define write_c0_staglo(val)	__write_32bit_c0_register($28, 4, val)
+
 #define read_c0_taghi()		__read_32bit_c0_register($29, 0)
 #define write_c0_taghi(val)	__write_32bit_c0_register($29, 0, val)
 
@@ -1082,6 +1088,51 @@ do {									\
 #define read_octeon_c0_dcacheerr()	__read_64bit_c0_register($27, 1)
 #define write_octeon_c0_dcacheerr(val)	__write_64bit_c0_register($27, 1, val)
 
+/* BMIPS3300 */
+#define read_c0_brcm_config_0()		__read_32bit_c0_register($22, 0)
+#define write_c0_brcm_config_0(val)	__write_32bit_c0_register($22, 0, val)
+
+#define read_c0_brcm_bus_pll()		__read_32bit_c0_register($22, 4)
+#define write_c0_brcm_bus_pll(val)	__write_32bit_c0_register($22, 4, val)
+
+#define read_c0_brcm_reset()		__read_32bit_c0_register($22, 5)
+#define write_c0_brcm_reset(val)	__write_32bit_c0_register($22, 5, val)
+
+/* BMIPS4380 */
+#define read_c0_brcm_cmt_intr()		__read_32bit_c0_register($22, 1)
+#define write_c0_brcm_cmt_intr(val)	__write_32bit_c0_register($22, 1, val)
+
+#define read_c0_brcm_cmt_ctrl()		__read_32bit_c0_register($22, 2)
+#define write_c0_brcm_cmt_ctrl(val)	__write_32bit_c0_register($22, 2, val)
+
+#define read_c0_brcm_cmt_local()	__read_32bit_c0_register($22, 3)
+#define write_c0_brcm_cmt_local(val)	__write_32bit_c0_register($22, 3, val)
+
+#define read_c0_brcm_config_1()		__read_32bit_c0_register($22, 5)
+#define write_c0_brcm_config_1(val)	__write_32bit_c0_register($22, 5, val)
+
+#define read_c0_brcm_cbr()		__read_32bit_c0_register($22, 6)
+#define write_c0_brcm_cbr(val)		__write_32bit_c0_register($22, 6, val)
+
+/* BMIPS5000 */
+#define read_c0_brcm_config()		__read_32bit_c0_register($22, 0)
+#define write_c0_brcm_config(val)	__write_32bit_c0_register($22, 0, val)
+
+#define read_c0_brcm_mode()		__read_32bit_c0_register($22, 1)
+#define write_c0_brcm_mode(val)		__write_32bit_c0_register($22, 1, val)
+
+#define read_c0_brcm_action()		__read_32bit_c0_register($22, 2)
+#define write_c0_brcm_action(val)	__write_32bit_c0_register($22, 2, val)
+
+#define read_c0_brcm_edsp()		__read_32bit_c0_register($22, 3)
+#define write_c0_brcm_edsp(val)		__write_32bit_c0_register($22, 3, val)
+
+#define read_c0_brcm_bootvec()		__read_32bit_c0_register($22, 4)
+#define write_c0_brcm_bootvec(val)	__write_32bit_c0_register($22, 4, val)
+
+#define read_c0_brcm_sleepcount()	__read_32bit_c0_register($22, 7)
+#define write_c0_brcm_sleepcount(val)	__write_32bit_c0_register($22, 7, val)
+
 /*
  * Macros to access the floating point coprocessor control registers
  */
-- 
1.7.0.4

