Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1BQDAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:00:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1BQC7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D56/D1X/BZAPeft8JyFc/gT12YYJIY22ZB8Ny+iSTsb/1lrSrgG646EWnrBDgne39D
         KEHIBGc633w+SF5JrO8rfUVU0QYuE3ipxZhSCgMWuaG9SEGqIMWx5XlhAfVu3mZJo5iE
         gwHCTNsiJThoVfDJ5kijjfSfpznszoqJH5rAU=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 07/10] Staging: tidspbridge: fixed spaces at the start of a line coding style issues.
Date: Thu, 17 Feb 2011 03:58:51 +0100
Message-Id: <1297911534-31534-7-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-6-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-5-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-6-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/hw/MMURegAcM.h b/drivers/staging/tidspbridge/hw/MMURegAcM.h
index ab1a16d..4e2647a 100644
--- a/drivers/staging/tidspbridge/hw/MMURegAcM.h
+++ b/drivers/staging/tidspbridge/hw/MMURegAcM.h
@@ -25,199 +25,199 @@
 #if defined(USE_LEVEL_1_MACROS)
 
 #define MMUMMU_SYSCONFIG_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_SYSCONFIG_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_SYSCONFIG_OFFSET))
 
 #define MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_IDLE_MODE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_IDLE_MODE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32);\
+	data &= ~(MMU_MMU_SYSCONFIG_IDLE_MODE_MASK);\
+	new_value <<= MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET;\
+	new_value &= MMU_MMU_SYSCONFIG_IDLE_MODE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32);\
+	data &= ~(MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK);\
+	new_value <<= MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET;\
+	new_value &= MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_IRQSTATUS_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(easil1_mmummu_irqstatus_read_register32),\
-      __raw_readl((base_address)+MMU_MMU_IRQSTATUS_OFFSET))
+	(_DEBUG_LEVEL1_EASI(easil1_mmummu_irqstatus_read_register32),\
+		__raw_readl((base_address)+MMU_MMU_IRQSTATUS_OFFSET))
 
 #define MMUMMU_IRQSTATUS_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_IRQSTATUS_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_IRQSTATUS_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_IRQENABLE_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_IRQENABLE_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_IRQENABLE_OFFSET))
 
 #define MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_IRQENABLE_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_IRQENABLE_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_WALKING_STTWL_RUNNING_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_WALKING_ST_OFFSET))))\
-      & MMU_MMU_WALKING_ST_TWL_RUNNING_MASK) >>\
-      MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_WALKING_ST_OFFSET))))\
+		& MMU_MMU_WALKING_ST_TWL_RUNNING_MASK) >>\
+		MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET))
 
 #define MMUMMU_CNTLTWL_ENABLE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_CNTL_OFFSET)))) &\
-      MMU_MMU_CNTL_TWL_ENABLE_MASK) >>\
-      MMU_MMU_CNTL_TWL_ENABLE_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_CNTL_OFFSET)))) &\
+		MMU_MMU_CNTL_TWL_ENABLE_MASK) >>\
+		MMU_MMU_CNTL_TWL_ENABLE_OFFSET))
 
 #define MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_TWL_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_TWL_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_TWL_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_CNTL_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32);\
+	data &= ~(MMU_MMU_CNTL_TWL_ENABLE_MASK);\
+	new_value <<= MMU_MMU_CNTL_TWL_ENABLE_OFFSET;\
+	new_value &= MMU_MMU_CNTL_TWL_ENABLE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_MMU_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_MMU_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_MMU_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_CNTL_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32);\
+	data &= ~(MMU_MMU_CNTL_MMU_ENABLE_MASK);\
+	new_value <<= MMU_MMU_CNTL_MMU_ENABLE_OFFSET;\
+	new_value &= MMU_MMU_CNTL_MMU_ENABLE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_FAULT_AD_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_FAULT_AD_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_FAULT_AD_OFFSET))
 
 #define MMUMMU_TTB_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_TTB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_TTB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_TTB_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_TTB_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_LOCK_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LOCK_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_LOCK_OFFSET))
 
 #define MMUMMU_LOCK_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_LOCK_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_LOCK_BASE_VALUE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_BASE_VALUE_MASK) >>\
-      MMU_MMU_LOCK_BASE_VALUE_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
+		MMU_MMU_LOCK_BASE_VALUE_MASK) >>\
+		MMU_MMU_LOCK_BASE_VALUE_OFFSET))
 
 #define MMUMMU_LOCK_BASE_VALUE_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(easil1_mmummu_lock_base_value_write32);\
-    data &= ~(MMU_MMU_LOCK_BASE_VALUE_MASK);\
-    new_value <<= MMU_MMU_LOCK_BASE_VALUE_OFFSET;\
-    new_value &= MMU_MMU_LOCK_BASE_VALUE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_LOCK_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(easil1_mmummu_lock_base_value_write32);\
+	data &= ~(MMU_MMU_LOCK_BASE_VALUE_MASK);\
+	new_value <<= MMU_MMU_LOCK_BASE_VALUE_OFFSET;\
+	new_value &= MMU_MMU_LOCK_BASE_VALUE_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_LOCK_CURRENT_VICTIM_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK) >>\
-      MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32),\
+		(((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
+		MMU_MMU_LOCK_CURRENT_VICTIM_MASK) >>\
+		MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET))
 
 #define MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32);\
-    data &= ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK);\
-    new_value <<= MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET;\
-    new_value &= MMU_MMU_LOCK_CURRENT_VICTIM_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
+	const u32 offset = MMU_MMU_LOCK_OFFSET;\
+	register u32 data = __raw_readl((base_address)+offset);\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32);\
+	data &= ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK);\
+	new_value <<= MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET;\
+	new_value &= MMU_MMU_LOCK_CURRENT_VICTIM_MASK;\
+	new_value |= data;\
+	__raw_writel(new_value, base_address+offset);\
 }
 
 #define MMUMMU_LOCK_CURRENT_VICTIM_SET32(var, value)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32),\
-      (((var) & ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK)) |\
-      (((value) << MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK)))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32),\
+		(((var) & ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK)) |\
+		(((value) << MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET) &\
+		MMU_MMU_LOCK_CURRENT_VICTIM_MASK)))
 
 #define MMUMMU_LD_TLB_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LD_TLB_OFFSET))
+	(_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_READ_REGISTER32),\
+		__raw_readl((base_address)+MMU_MMU_LD_TLB_OFFSET))
 
 #define MMUMMU_LD_TLB_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_LD_TLB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_LD_TLB_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_CAM_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_CAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_CAM_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CAM_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_RAM_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_RAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_RAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_RAM_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_RAM_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #define MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(base_address, value)\
 {\
-    const u32 offset = MMU_MMU_FLUSH_ENTRY_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
+	const u32 offset = MMU_MMU_FLUSH_ENTRY_OFFSET;\
+	register u32 new_value = (value);\
+	_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32);\
+	__raw_writel(new_value, (base_address)+offset);\
 }
 
 #endif /* USE_LEVEL_1_MACROS */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbc.h b/drivers/staging/tidspbridge/include/dspbridge/dbc.h
index 463760f..26caead 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbc.h
@@ -29,9 +29,9 @@
 #ifdef CONFIG_TIDSPBRIDGE_DEBUG
 
 #define DBC_ASSERT(exp) \
-    if (!(exp)) \
-	pr_err("%s, line %d: Assertion (" #exp ") failed.\n", \
-	__FILE__, __LINE__)
+	if (!(exp)) \
+		pr_err("%s, line %d: Assertion (" #exp ") failed.\n", \
+		__FILE__, __LINE__)
 #define DBC_REQUIRE DBC_ASSERT	/* Function Precondition. */
 #define DBC_ENSURE  DBC_ASSERT	/* Function Postcondition. */
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index cf30048..4fb095e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -640,8 +640,9 @@ typedef int(*fxn_chnl_idle) (struct chnl_object *chnl_obj,
  *  Ensures:
  */
 typedef int(*fxn_chnl_registernotify)
- (struct chnl_object *chnl_obj,
-  u32 event_mask, u32 notify_type, struct dsp_notification *hnotification);
+	(struct chnl_object *chnl_obj,
+	u32 event_mask, u32 notify_type,
+	struct dsp_notification *hnotification);
 
 /*
  *  ======== bridge_dev_create ========
@@ -818,8 +819,8 @@ typedef int(*fxn_io_getprocload) (struct io_mgr *hio_mgr,
  *  Ensures:
  */
 typedef int(*fxn_msg_create)
- (struct msg_mgr **msg_man,
-  struct dev_object *hdev_obj, msg_onexit msg_callback);
+	(struct msg_mgr **msg_man,
+	struct dev_object *hdev_obj, msg_onexit msg_callback);
 
 /*
  *  ======== bridge_msg_create_queue ========
@@ -844,8 +845,8 @@ typedef int(*fxn_msg_create)
  *      msgq !=NULL <==> 0.
  */
 typedef int(*fxn_msg_createqueue)
- (struct msg_mgr *hmsg_mgr,
-  struct msg_queue **msgq, u32 msgq_id, u32 max_msgs, void *h);
+	(struct msg_mgr *hmsg_mgr,
+	struct msg_queue **msgq, u32 msgq_id, u32 max_msgs, void *h);
 
 /*
  *  ======== bridge_msg_delete ========
@@ -940,8 +941,9 @@ typedef int(*fxn_msg_put) (struct msg_queue *msg_queue_obj,
  *  Ensures:
  */
 typedef int(*fxn_msg_registernotify)
- (struct msg_queue *msg_queue_obj,
-  u32 event_mask, u32 notify_type, struct dsp_notification *hnotification);
+	(struct msg_queue *msg_queue_obj,
+	u32 event_mask, u32 notify_type,
+	struct dsp_notification *hnotification);
 
 /*
  *  ======== bridge_msg_set_queue_id ========
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 132e960..adca71e 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -1093,8 +1093,8 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 
 	/* Local helper macro: */
 #define  STORE_FXN(cast, pfn) \
-    (intf_fxns->pfn = ((drv_fxns->pfn != NULL) ? drv_fxns->pfn : \
-    (cast)fxn_not_implemented))
+	(intf_fxns->pfn = ((drv_fxns->pfn != NULL) ? drv_fxns->pfn : \
+		(cast)fxn_not_implemented))
 
 	DBC_REQUIRE(intf_fxns != NULL);
 	DBC_REQUIRE(drv_fxns != NULL);
-- 
1.7.1

