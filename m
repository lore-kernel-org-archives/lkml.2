Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0LUVlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:41:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38494 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752862Ab0LUVli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:41:38 -0500
X-Authenticated: #27200637
X-Provags-ID: V01U2FsdGVkX19BOahFeiFBYc9lcUOob55Fc9T+jRs8LB3Uq9soM/
	jFivBwfiEMMwei
From: =?UTF-8?q?Jan=20F=C3=BCsting?= <jan.fuesting@gmx.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20F=C3=BCsting?= <jan.fuesting@gmx.de>
Subject: [PATCH 2/2] ACPI: Fixed some coding style issues in fan.c and battery.c
Date: Tue, 21 Dec 2010 22:41:20 +0100
Message-Id: <1292967680-14208-1-git-send-email-jan.fuesting@gmx.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues in fan.c and battery.c

Signed-off-by: Jan Füsting <jan.fuesting@gmx.de>
---
 drivers/acpi/battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 16fc4df..35d0c6f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -580,7 +580,7 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
 {
 	if (dmi_name_in_vendors("Acer") && battery->power_unit)
 		set_bit(ACPI_BATTERY_QUIRK_SIGNED16_CURRENT, &battery->flags);
-}	
+}
 
 /*
  * According to the ACPI spec, some kinds of primary batteries can
-- 
1.7.2.3

