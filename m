Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0ELOZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:25:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab0ELOZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:25:37 -0400
From: Peter Jones <pjones@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
       gpxe-devel@etherboot.org, Peter Jones <pjones@redhat.com>
Subject: [PATCH] Use IBFT_SIGN instead of open-coding the search string.
Date: Wed, 12 May 2010 10:25:08 -0400
Message-Id: <1273674308-9366-1-git-send-email-pjones@redhat.com>
In-Reply-To: <4BEAB683.8040600@redhat.com>
References: <4BEAB683.8040600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We define IBFT_SIGN to "iBFT"; may as well use it.

Signed-of-by: Peter Jones <pjones@redhat.com>
---
 drivers/firmware/iscsi_ibft_find.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index 82a7a15..2192456 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -100,7 +100,7 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 	if (!ibft_addr)
 		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
 	if (!ibft_addr)
-		acpi_table_parse("iBFT", acpi_find_ibft);
+		acpi_table_parse(IBFT_SIGN, acpi_find_ibft);
 #endif /* CONFIG_ACPI */
 
 	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
-- 
1.7.0.1

