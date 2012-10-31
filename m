Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422986Ab2JaOgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:36:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422958Ab2JaOfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:35:52 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, Fenghua Yu <fengguang.wu@intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/3] ACPI: Make acpi_table_checksum static
Date: Wed, 31 Oct 2012 15:35:46 +0100
Message-Id: <1351694147-10904-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1351694147-10904-1-git-send-email-trenn@suse.de>
References: <1351694147-10904-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fengguang.wu@intel.com>

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 drivers/acpi/osl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index a2845ff..a873c4f 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -542,7 +542,7 @@ static u64 acpi_tables_addr;
 static int all_tables_size;
 
 /* Copied from acpica/tbutils.c:acpi_tb_checksum() */
-u8 __init acpi_table_checksum(u8 *buffer, u32 length)
+static u8 __init acpi_table_checksum(u8 *buffer, u32 length)
 {
 	u8 sum = 0;
 	u8 *end = buffer + length;
-- 
1.7.6.1

