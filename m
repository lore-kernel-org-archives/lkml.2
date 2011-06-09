Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1FIBEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:04:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1FIBEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mRKVJXfQ74gfLGsmKRNkdLkiNzyJEzInk8Bq/WVHPH+afJhWlSKFzVq3ewOWfwSm/N
         +xgEhs6N9aAnl5cldh0vr70/g3UO3gj1tY3eavGCBxlm9q3jXBXiQPBQyq6tZ0rwS08r
         l5/9RpPg4lBUCjijGc9t2wPVsSnuwCyt4peXo=
From: Wu DaoGuang <wdgvip@gmail.com>
To: ben-linux@fluff.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wdgvip@gmail.com
Subject: [PATCH 3/4] This patch fixed the Kconfig for mach-ok2440.c
Date: Thu,  9 Jun 2011 09:03:21 +0800
Message-Id: <1307581402-3808-3-git-send-email-wdgvip@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307581402-3808-1-git-send-email-wdgvip@gmail.com>
References: <1307581402-3808-1-git-send-email-wdgvip@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Kconfig to support ok2440 development board.

The following patches are against v3.0-rc2.

Signed-off-by: Wu DaoGuang <wdgvip@gmail.com>
---
 arch/arm/mach-s3c2440/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index 50825a3..9b1024d 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -176,6 +176,15 @@ config MACH_AT2440EVB
 	help
 	  Say Y here if you are using the AT2440EVB development board
 
+config MACH_OK2440
+	bool "OK2440 development board"
+	select CPU_S3C2440
+	select S3C2440_XTAL_12000000
+	select S3C_DEV_NAND
+	select S3C_DEV_USB_HOST
+	help
+	   Say y here to select support for OK2440. 
+
 config MACH_MINI2440
 	bool "MINI2440 development board"
 	select CPU_S3C2440
-- 
1.7.1

