Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2K2LxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:53:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2K2LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:53:21 -0500
From: Colin King <colin.king@canonical.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ACPICA: GPE support: remove unnecessary newline from error messages
Date: Thu, 29 Nov 2012 11:53:15 +0000
Message-Id: <1354189996-14431-5-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
References: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

ACPI_ERROR() already appends a newline, so there is no
need for the error messages to include one too.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/acpi/acpica/hwgpe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/hwgpe.c b/drivers/acpi/acpica/hwgpe.c
index db40765..610ed72 100644
--- a/drivers/acpi/acpica/hwgpe.c
+++ b/drivers/acpi/acpica/hwgpe.c
@@ -134,7 +134,7 @@ acpi_hw_low_set_gpe(struct acpi_gpe_event_info *gpe_event_info, u32 action)
 		break;
 
 	default:
-		ACPI_ERROR((AE_INFO, "Invalid GPE Action, %u\n", action));
+		ACPI_ERROR((AE_INFO, "Invalid GPE Action, %u", action));
 		return (AE_BAD_PARAMETER);
 	}
 
-- 
1.8.0

