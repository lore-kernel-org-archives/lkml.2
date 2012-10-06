Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2JFULZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:11:25 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44043 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2JFULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:11:21 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 04/49] ACPICA: Comment update: Fix some typos in actble.h
Date: Sat,  6 Oct 2012 16:09:25 -0400
Message-Id: <80187431762989ebade986468d3c548287a12689.1349554105.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

No functional change.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/actbl.h | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/acpi/actbl.h b/include/acpi/actbl.h
index 59a73e1..d54e358 100644
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -94,7 +94,7 @@
 struct acpi_table_header {
 	char signature[ACPI_NAME_SIZE];	/* ASCII table signature */
 	u32 length;		/* Length of table in bytes, including this header */
-	u8 revision;		/* ACPI Specification minor version # */
+	u8 revision;		/* ACPI Specification minor version number */
 	u8 checksum;		/* To make sum of entire table == 0 */
 	char oem_id[ACPI_OEM_ID_SIZE];	/* ASCII OEM identification */
 	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];	/* ASCII OEM table identification */
@@ -108,7 +108,7 @@ struct acpi_table_header {
  * GAS - Generic Address Structure (ACPI 2.0+)
  *
  * Note: Since this structure is used in the ACPI tables, it is byte aligned.
- * If misaliged access is not supported by the hardware, accesses to the
+ * If misaligned access is not supported by the hardware, accesses to the
  * 64-bit Address field must be performed with care.
  *
  ******************************************************************************/
@@ -210,18 +210,18 @@ struct acpi_table_fadt {
 	u8 preferred_profile;	/* Conveys preferred power management profile to OSPM. */
 	u16 sci_interrupt;	/* System vector of SCI interrupt */
 	u32 smi_command;	/* 32-bit Port address of SMI command port */
-	u8 acpi_enable;		/* Value to write to smi_cmd to enable ACPI */
-	u8 acpi_disable;	/* Value to write to smi_cmd to disable ACPI */
-	u8 s4_bios_request;	/* Value to write to SMI CMD to enter S4BIOS state */
+	u8 acpi_enable;		/* Value to write to SMI_CMD to enable ACPI */
+	u8 acpi_disable;	/* Value to write to SMI_CMD to disable ACPI */
+	u8 s4_bios_request;	/* Value to write to SMI_CMD to enter S4BIOS state */
 	u8 pstate_control;	/* Processor performance state control */
-	u32 pm1a_event_block;	/* 32-bit Port address of Power Mgt 1a Event Reg Blk */
-	u32 pm1b_event_block;	/* 32-bit Port address of Power Mgt 1b Event Reg Blk */
-	u32 pm1a_control_block;	/* 32-bit Port address of Power Mgt 1a Control Reg Blk */
-	u32 pm1b_control_block;	/* 32-bit Port address of Power Mgt 1b Control Reg Blk */
-	u32 pm2_control_block;	/* 32-bit Port address of Power Mgt 2 Control Reg Blk */
-	u32 pm_timer_block;	/* 32-bit Port address of Power Mgt Timer Ctrl Reg Blk */
-	u32 gpe0_block;		/* 32-bit Port address of General Purpose Event 0 Reg Blk */
-	u32 gpe1_block;		/* 32-bit Port address of General Purpose Event 1 Reg Blk */
+	u32 pm1a_event_block;	/* 32-bit port address of Power Mgt 1a Event Reg Blk */
+	u32 pm1b_event_block;	/* 32-bit port address of Power Mgt 1b Event Reg Blk */
+	u32 pm1a_control_block;	/* 32-bit port address of Power Mgt 1a Control Reg Blk */
+	u32 pm1b_control_block;	/* 32-bit port address of Power Mgt 1b Control Reg Blk */
+	u32 pm2_control_block;	/* 32-bit port address of Power Mgt 2 Control Reg Blk */
+	u32 pm_timer_block;	/* 32-bit port address of Power Mgt Timer Ctrl Reg Blk */
+	u32 gpe0_block;		/* 32-bit port address of General Purpose Event 0 Reg Blk */
+	u32 gpe1_block;		/* 32-bit port address of General Purpose Event 1 Reg Blk */
 	u8 pm1_event_length;	/* Byte Length of ports at pm1x_event_block */
 	u8 pm1_control_length;	/* Byte Length of ports at pm1x_control_block */
 	u8 pm2_control_length;	/* Byte Length of ports at pm2_control_block */
@@ -229,12 +229,12 @@ struct acpi_table_fadt {
 	u8 gpe0_block_length;	/* Byte Length of ports at gpe0_block */
 	u8 gpe1_block_length;	/* Byte Length of ports at gpe1_block */
 	u8 gpe1_base;		/* Offset in GPE number space where GPE1 events start */
-	u8 cst_control;		/* Support for the _CST object and C States change notification */
+	u8 cst_control;		/* Support for the _CST object and C-States change notification */
 	u16 c2_latency;		/* Worst case HW latency to enter/exit C2 state */
 	u16 c3_latency;		/* Worst case HW latency to enter/exit C3 state */
-	u16 flush_size;		/* Processor's memory cache line width, in bytes */
+	u16 flush_size;		/* Processor memory cache line width, in bytes */
 	u16 flush_stride;	/* Number of flush strides that need to be read */
-	u8 duty_offset;		/* Processor duty cycle index in processor's P_CNT reg */
+	u8 duty_offset;		/* Processor duty cycle index in processor P_CNT reg */
 	u8 duty_width;		/* Processor duty cycle value bit width in P_CNT register */
 	u8 day_alarm;		/* Index to day-of-month alarm in RTC CMOS RAM */
 	u8 month_alarm;		/* Index to month-of-year alarm in RTC CMOS RAM */
@@ -255,11 +255,11 @@ struct acpi_table_fadt {
 	struct acpi_generic_address xpm_timer_block;	/* 64-bit Extended Power Mgt Timer Ctrl Reg Blk address */
 	struct acpi_generic_address xgpe0_block;	/* 64-bit Extended General Purpose Event 0 Reg Blk address */
 	struct acpi_generic_address xgpe1_block;	/* 64-bit Extended General Purpose Event 1 Reg Blk address */
-	struct acpi_generic_address sleep_control;	/* 64-bit Sleep Control register */
-	struct acpi_generic_address sleep_status;	/* 64-bit Sleep Status register */
+	struct acpi_generic_address sleep_control;	/* 64-bit Sleep Control register (ACPI 5.0) */
+	struct acpi_generic_address sleep_status;	/* 64-bit Sleep Status register (ACPI 5.0) */
 };
 
-/* Masks for FADT Boot Architecture Flags (boot_flags) */
+/* Masks for FADT Boot Architecture Flags (boot_flags) [Vx]=Introduced in this FADT revision */
 
 #define ACPI_FADT_LEGACY_DEVICES    (1)  	/* 00: [V2] System has LPC or ISA bus devices */
 #define ACPI_FADT_8042              (1<<1)	/* 01: [V3] System has an 8042 controller on port 60/64 */
@@ -272,13 +272,13 @@ struct acpi_table_fadt {
 
 /* Masks for FADT flags */
 
-#define ACPI_FADT_WBINVD            (1)	/* 00: [V1] The wbinvd instruction works properly */
-#define ACPI_FADT_WBINVD_FLUSH      (1<<1)	/* 01: [V1] wbinvd flushes but does not invalidate caches */
+#define ACPI_FADT_WBINVD            (1)	/* 00: [V1] The WBINVD instruction works properly */
+#define ACPI_FADT_WBINVD_FLUSH      (1<<1)	/* 01: [V1] WBINVD flushes but does not invalidate caches */
 #define ACPI_FADT_C1_SUPPORTED      (1<<2)	/* 02: [V1] All processors support C1 state */
 #define ACPI_FADT_C2_MP_SUPPORTED   (1<<3)	/* 03: [V1] C2 state works on MP system */
 #define ACPI_FADT_POWER_BUTTON      (1<<4)	/* 04: [V1] Power button is handled as a control method device */
 #define ACPI_FADT_SLEEP_BUTTON      (1<<5)	/* 05: [V1] Sleep button is handled as a control method device */
-#define ACPI_FADT_FIXED_RTC         (1<<6)	/* 06: [V1] RTC wakeup status not in fixed register space */
+#define ACPI_FADT_FIXED_RTC         (1<<6)	/* 06: [V1] RTC wakeup status is not in fixed register space */
 #define ACPI_FADT_S4_RTC_WAKE       (1<<7)	/* 07: [V1] RTC alarm can wake system from S4 */
 #define ACPI_FADT_32BIT_TIMER       (1<<8)	/* 08: [V1] ACPI timer width is 32-bit (0=24-bit) */
 #define ACPI_FADT_DOCKING_SUPPORTED (1<<9)	/* 09: [V1] Docking supported */
@@ -297,7 +297,7 @@ struct acpi_table_fadt {
 
 /* Values for preferred_profile (Preferred Power Management Profiles) */
 
-enum acpi_prefered_pm_profiles {
+enum acpi_preferred_pm_profiles {
 	PM_UNSPECIFIED = 0,
 	PM_DESKTOP = 1,
 	PM_MOBILE = 2,
@@ -335,7 +335,7 @@ union acpi_name_union {
 struct acpi_table_desc {
 	acpi_physical_address address;
 	struct acpi_table_header *pointer;
-	u32 length;		/* Length fixed at 32 bits */
+	u32 length;		/* Length fixed at 32 bits (fixed in table header) */
 	union acpi_name_union signature;
 	acpi_owner_id owner_id;
 	u8 flags;
-- 
1.8.0.rc0.18.gf84667d

