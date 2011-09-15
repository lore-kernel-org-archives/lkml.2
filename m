Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776Ab1IOUOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:14:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:48932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934733Ab1IOUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873435"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, davej@redhat.com
Subject: [PATCH 10/27] Initconst section fixes for CPUFREQ
Date: Thu, 15 Sep 2011 13:09:37 -0700
Message-Id: <1316117394-21666-11-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: davej@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/cpufreq/longhaul.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/longhaul.h b/drivers/cpufreq/longhaul.h
index cbf48fb..e2dc436 100644
--- a/drivers/cpufreq/longhaul.h
+++ b/drivers/cpufreq/longhaul.h
@@ -56,7 +56,7 @@ union msr_longhaul {
 /*
  * VIA C3 Samuel 1  & Samuel 2 (stepping 0)
  */
-static const int __cpuinitdata samuel1_mults[16] = {
+static const int __cpuinitconst samuel1_mults[16] = {
 	-1, /* 0000 -> RESERVED */
 	30, /* 0001 ->  3.0x */
 	40, /* 0010 ->  4.0x */
@@ -75,7 +75,7 @@ static const int __cpuinitdata samuel1_mults[16] = {
 	-1, /* 1111 -> RESERVED */
 };
 
-static const int __cpuinitdata samuel1_eblcr[16] = {
+static const int __cpuinitconst samuel1_eblcr[16] = {
 	50, /* 0000 -> RESERVED */
 	30, /* 0001 ->  3.0x */
 	40, /* 0010 ->  4.0x */
@@ -97,7 +97,7 @@ static const int __cpuinitdata samuel1_eblcr[16] = {
 /*
  * VIA C3 Samuel2 Stepping 1->15
  */
-static const int __cpuinitdata samuel2_eblcr[16] = {
+static const int __cpuinitconst samuel2_eblcr[16] = {
 	50,  /* 0000 ->  5.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -119,7 +119,7 @@ static const int __cpuinitdata samuel2_eblcr[16] = {
 /*
  * VIA C3 Ezra
  */
-static const int __cpuinitdata ezra_mults[16] = {
+static const int __cpuinitconst ezra_mults[16] = {
 	100, /* 0000 -> 10.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -138,7 +138,7 @@ static const int __cpuinitdata ezra_mults[16] = {
 	120, /* 1111 -> 12.0x */
 };
 
-static const int __cpuinitdata ezra_eblcr[16] = {
+static const int __cpuinitconst ezra_eblcr[16] = {
 	50,  /* 0000 ->  5.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -160,7 +160,7 @@ static const int __cpuinitdata ezra_eblcr[16] = {
 /*
  * VIA C3 (Ezra-T) [C5M].
  */
-static const int __cpuinitdata ezrat_mults[32] = {
+static const int __cpuinitconst ezrat_mults[32] = {
 	100, /* 0000 -> 10.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -196,7 +196,7 @@ static const int __cpuinitdata ezrat_mults[32] = {
 	-1,  /* 1111 -> RESERVED (12.0x) */
 };
 
-static const int __cpuinitdata ezrat_eblcr[32] = {
+static const int __cpuinitconst ezrat_eblcr[32] = {
 	50,  /* 0000 ->  5.0x */
 	30,  /* 0001 ->  3.0x */
 	40,  /* 0010 ->  4.0x */
@@ -235,7 +235,7 @@ static const int __cpuinitdata ezrat_eblcr[32] = {
 /*
  * VIA C3 Nehemiah */
 
-static const int __cpuinitdata nehemiah_mults[32] = {
+static const int __cpuinitconst nehemiah_mults[32] = {
 	100, /* 0000 -> 10.0x */
 	-1, /* 0001 -> 16.0x */
 	40,  /* 0010 ->  4.0x */
@@ -270,7 +270,7 @@ static const int __cpuinitdata nehemiah_mults[32] = {
 	-1, /* 1111 -> 12.0x */
 };
 
-static const int __cpuinitdata nehemiah_eblcr[32] = {
+static const int __cpuinitconst nehemiah_eblcr[32] = {
 	50,  /* 0000 ->  5.0x */
 	160, /* 0001 -> 16.0x */
 	40,  /* 0010 ->  4.0x */
@@ -315,7 +315,7 @@ struct mV_pos {
 	unsigned short pos;
 };
 
-static const struct mV_pos __cpuinitdata vrm85_mV[32] = {
+static const struct mV_pos __cpuinitconst vrm85_mV[32] = {
 	{1250, 8},	{1200, 6},	{1150, 4},	{1100, 2},
 	{1050, 0},	{1800, 30},	{1750, 28},	{1700, 26},
 	{1650, 24},	{1600, 22},	{1550, 20},	{1500, 18},
@@ -326,14 +326,14 @@ static const struct mV_pos __cpuinitdata vrm85_mV[32] = {
 	{1475, 17},	{1425, 15},	{1375, 13},	{1325, 11}
 };
 
-static const unsigned char __cpuinitdata mV_vrm85[32] = {
+static const unsigned char __cpuinitconst mV_vrm85[32] = {
 	0x04,	0x14,	0x03,	0x13,	0x02,	0x12,	0x01,	0x11,
 	0x00,	0x10,	0x0f,	0x1f,	0x0e,	0x1e,	0x0d,	0x1d,
 	0x0c,	0x1c,	0x0b,	0x1b,	0x0a,	0x1a,	0x09,	0x19,
 	0x08,	0x18,	0x07,	0x17,	0x06,	0x16,	0x05,	0x15
 };
 
-static const struct mV_pos __cpuinitdata mobilevrm_mV[32] = {
+static const struct mV_pos __cpuinitconst mobilevrm_mV[32] = {
 	{1750, 31},	{1700, 30},	{1650, 29},	{1600, 28},
 	{1550, 27},	{1500, 26},	{1450, 25},	{1400, 24},
 	{1350, 23},	{1300, 22},	{1250, 21},	{1200, 20},
@@ -344,7 +344,7 @@ static const struct mV_pos __cpuinitdata mobilevrm_mV[32] = {
 	{675, 3},	{650, 2},	{625, 1},	{600, 0}
 };
 
-static const unsigned char __cpuinitdata mV_mobilevrm[32] = {
+static const unsigned char __cpuinitconst mV_mobilevrm[32] = {
 	0x1f,	0x1e,	0x1d,	0x1c,	0x1b,	0x1a,	0x19,	0x18,
 	0x17,	0x16,	0x15,	0x14,	0x13,	0x12,	0x11,	0x10,
 	0x0f,	0x0e,	0x0d,	0x0c,	0x0b,	0x0a,	0x09,	0x08,
-- 
1.7.4.4

