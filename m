Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2K2LxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:53:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35016 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab2K2LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:53:21 -0500
From: Colin King <colin.king@canonical.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ACPI thermal: remove unnecessary newline from exception message
Date: Thu, 29 Nov 2012 11:53:16 +0000
Message-Id: <1354189996-14431-6-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
References: <1354189996-14431-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

ACPI_EXCEPTION() already appends a newline, so there is no
need for the thermal trip point message to include one too.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/acpi/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 804204d..2020d44 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -288,7 +288,7 @@ do {	\
 	if (flags != ACPI_TRIPS_INIT)	\
 		ACPI_EXCEPTION((AE_INFO, AE_ERROR,	\
 		"ACPI thermal trip point %s changed\n"	\
-		"Please send acpidump to linux-acpi@vger.kernel.org\n", str)); \
+		"Please send acpidump to linux-acpi@vger.kernel.org", str)); \
 } while (0)
 
 static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
-- 
1.8.0

