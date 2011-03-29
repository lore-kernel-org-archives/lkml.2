Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1C2WWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:14 -0400
Received: from mail.perches.com ([173.55.12.10]:4344 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1C2WWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:12 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>, Corentin Chary <corentincj@iksaif.net>
Cc: acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/23] asus-wmi: Remove __init from asus_wmi_platform_init
Date: Tue, 29 Mar 2011 15:21:32 -0700
Message-Id: <ae73e8c570d9ee701af6bad5c1479c3615418826.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's used by a non-init function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/asus-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index efc776c..c382af6 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1223,7 +1223,7 @@ static int asus_wmi_sysfs_init(struct platform_device *device)
 /*
  * Platform device
  */
-static int __init asus_wmi_platform_init(struct asus_wmi *asus)
+static int asus_wmi_platform_init(struct asus_wmi *asus)
 {
 	int rv;
 
-- 
1.7.4.2.g597a6.dirty

