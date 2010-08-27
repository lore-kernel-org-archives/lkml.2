Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0H0W73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:59:29 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56161 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab0H0W7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:59:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Barry Song <barry.song@analog.com>
Subject: [PATCH 2/2] Blackfin: bf52x/bf54x boards: drop unused nand page size
Date: Fri, 27 Aug 2010 19:08:38 -0400
Message-Id: <1282950518-7094-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282950518-7094-1-git-send-email-vapier@gentoo.org>
References: <1282950518-7094-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

Now that the driver for the Blackfin on-chip NFC no longer uses/respects
the page_size from the platform resources (figures out the needs on the
fly), drop it from the platform resources.  This fixes some build errors
since the defines no longer exists.

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c |    1 -
 arch/blackfin/mach-bf527/boards/ezbrd.c    |    1 -
 arch/blackfin/mach-bf527/boards/ezkit.c    |    1 -
 arch/blackfin/mach-bf548/boards/cm_bf548.c |    1 -
 arch/blackfin/mach-bf548/boards/ezkit.c    |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index f392af6..645ba5c 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -145,7 +145,6 @@ static struct mtd_partition partition_info[] = {
 };
 
 static struct bf5xx_nand_platform bf5xx_nand_platform = {
-	.page_size = NFC_PG_SIZE_256,
 	.data_width = NFC_NWIDTH_8,
 	.partitions = partition_info,
 	.nr_partitions = ARRAY_SIZE(partition_info),
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 606eb36..c975fe8 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -149,7 +149,6 @@ static struct mtd_partition partition_info[] = {
 };
 
 static struct bf5xx_nand_platform bf5xx_nand_platform = {
-	.page_size = NFC_PG_SIZE_256,
 	.data_width = NFC_NWIDTH_8,
 	.partitions = partition_info,
 	.nr_partitions = ARRAY_SIZE(partition_info),
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index a05c967..87b41e9 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -234,7 +234,6 @@ static struct mtd_partition partition_info[] = {
 };
 
 static struct bf5xx_nand_platform bf5xx_nand_platform = {
-	.page_size = NFC_PG_SIZE_256,
 	.data_width = NFC_NWIDTH_8,
 	.partitions = partition_info,
 	.nr_partitions = ARRAY_SIZE(partition_info),
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index dbb6b1d..0c38eec 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -706,7 +706,6 @@ static struct mtd_partition partition_info[] = {
 };
 
 static struct bf5xx_nand_platform bf5xx_nand_platform = {
-	.page_size = NFC_PG_SIZE_256,
 	.data_width = NFC_NWIDTH_8,
 	.partitions = partition_info,
 	.nr_partitions = ARRAY_SIZE(partition_info),
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index 6fcfb91..56682a3 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -849,7 +849,6 @@ static struct mtd_partition partition_info[] = {
 };
 
 static struct bf5xx_nand_platform bf5xx_nand_platform = {
-	.page_size = NFC_PG_SIZE_256,
 	.data_width = NFC_NWIDTH_8,
 	.partitions = partition_info,
 	.nr_partitions = ARRAY_SIZE(partition_info),
-- 
1.7.2.2

