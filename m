Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1HBURn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:17:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35031 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754944Ab1HBURh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:17:37 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19ZOQBFCoZZddt3JEIZtPPH3dfv4eiPULDwDZy+sX
	wLG0Dqckp7D8z+
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] staging: rtl8192u: declare MODULE_FIRMWARE
Date: Tue, 2 Aug 2011 22:17:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-0.slh.5-aptosid-686; KDE/4.6.5; i686; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108022217.27859.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

declaring MODULE_FIRMWARE has apparently forgotten while removing the embedded
firmware arrays in 0a8692b534e18fcec6eac07551bb37a22659f5c7 (rtl8192u_usb:
Remove built-in firmware images).

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: stable <stable@kernel.org> [2.6.39+]
---
 drivers/staging/rtl8192u/r819xU_firmware.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index 6766f46..4bb5fff 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -399,10 +399,7 @@ download_firmware_fail:
 
 }
 
-
-
-
-
-
-
+MODULE_FIRMWARE("RTL8192U/boot.img");
+MODULE_FIRMWARE("RTL8192U/main.img");
+MODULE_FIRMWARE("RTL8192U/data.img");
 
-- 
1.7.5.4

