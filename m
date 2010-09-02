Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0IBU2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:28:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33793 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab0IBU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dZsbqA2ZA54UG/g2GvVGnytFw6Xv2SEpzpoBTwC2BhEUiQwTNfGUg0CVZ0Qs/30Czz
         1T1StGB5iq/HxnGdR61t+PypVDcaofZJQCk2+66Jgm5juWSgpJH2QhZw3mejkEz+JKyc
         3r+vfoZh0Ciuiyh0N/qx2VsqDduXunjnlAPxo=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: rientjes@google.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] acpi: numa: fixed white space and line length issue
Date: Thu,  2 Sep 2010 22:27:47 +0200
Message-Id: <1283459267-6171-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/acpi/numa.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 5718566..9864c5b 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -102,7 +102,7 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 					  "SRAT Processor (id[0x%02x] eid[0x%02x]) in proximity domain %d %s\n",
 					  p->apic_id, p->local_sapic_eid,
 					  p->proximity_domain_lo,
-					  (p->flags & ACPI_SRAT_CPU_ENABLED)?
+					  (p->flags & ACPI_SRAT_CPU_ENABLED) ?
 					  "enabled" : "disabled"));
 		}
 #endif				/* ACPI_DEBUG_OUTPUT */
@@ -118,9 +118,10 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 					  (unsigned long)p->base_address,
 					  (unsigned long)p->length,
 					  p->proximity_domain,
-					  (p->flags & ACPI_SRAT_MEM_ENABLED)?
+					  (p->flags & ACPI_SRAT_MEM_ENABLED) ?
 					  "enabled" : "disabled",
-					  (p->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)?
+					  (p->flags &
+						ACPI_SRAT_MEM_HOT_PLUGGABLE) ?
 					  " hot-pluggable" : ""));
 		}
 #endif				/* ACPI_DEBUG_OUTPUT */
@@ -236,7 +237,7 @@ acpi_parse_processor_affinity(struct acpi_subtable_header *header,
 }
 
 static int __init
-acpi_parse_memory_affinity(struct acpi_subtable_header * header,
+acpi_parse_memory_affinity(struct acpi_subtable_header *header,
 			   const unsigned long end)
 {
 	struct acpi_srat_mem_affinity *memory_affinity;
@@ -265,7 +266,8 @@ static int __init acpi_parse_srat(struct acpi_table_header *table)
 
 static int __init
 acpi_table_parse_srat(enum acpi_srat_type id,
-		      acpi_table_entry_handler handler, unsigned int max_entries)
+		      acpi_table_entry_handler handler,
+		      unsigned int max_entries)
 {
 	return acpi_table_parse_entries(ACPI_SIG_SRAT,
 					    sizeof(struct acpi_table_srat), id,
-- 
1.7.0.4

