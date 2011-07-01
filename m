Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1GAJfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:35:32 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:34231 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1GAJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:29 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 07/16] asus-wmi: fix section mismatch
Date: Fri,  1 Jul 2011 11:34:32 +0200
Message-Id: <1309512881-2901-8-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 619e3e3..fa6982a 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1711,7 +1711,7 @@ static int asus_wmi_probe(struct platform_device *pdev)
 
 static bool used;
 
-int asus_wmi_register_driver(struct asus_wmi_driver *driver)
+int __init_or_module asus_wmi_register_driver(struct asus_wmi_driver *driver)
 {
 	struct platform_driver *platform_driver;
 	struct platform_device *platform_device;
-- 
1.7.3.4

