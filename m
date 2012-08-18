Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2HRQZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:25:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56166 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2HRQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:20 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 05/11] ia64: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:49 -0300
Message-Id: <1345307035-3545-5-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345307035-3545-1-git-send-email-festevam@gmail.com>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed 
CONFIG_MISC_DEVICES option, so remove the occurrences from the config files 
as well

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/ia64/configs/generic_defconfig   |    1 -
 arch/ia64/configs/gensparse_defconfig |    1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/ia64/configs/generic_defconfig b/arch/ia64/configs/generic_defconfig
index 954d81e..7913695 100644
--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -234,5 +234,4 @@ CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD5=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRC_T10DIF=y
-CONFIG_MISC_DEVICES=y
 CONFIG_INTEL_IOMMU=y
diff --git a/arch/ia64/configs/gensparse_defconfig b/arch/ia64/configs/gensparse_defconfig
index 91c41ec..f8e9133 100644
--- a/arch/ia64/configs/gensparse_defconfig
+++ b/arch/ia64/configs/gensparse_defconfig
@@ -209,4 +209,3 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_CRYPTO_MD5=y
-CONFIG_MISC_DEVICES=y
-- 
1.7.9.5

