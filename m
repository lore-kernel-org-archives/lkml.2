Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2IIX2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:28:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51283 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039Ab2IIXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:32 -0400
Message-Id: <20120909224158.689722019@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 58/95] ACPI: export symbol acpi_get_table_with_size
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4f81f986761a7663db7d24d24cd6ae68008f1fc2 upstream.

We need it in the radeon drm module to fetch
and verify the vbios image on UEFI systems.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/acpica/tbxface.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index ea4c6d5..29e51bc 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -387,6 +387,7 @@ acpi_get_table_with_size(char *signature,
 
 	return (AE_NOT_FOUND);
 }
+ACPI_EXPORT_SYMBOL(acpi_get_table_with_size)
 
 acpi_status
 acpi_get_table(char *signature,


