Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab2HPOtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:49:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63823 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2HPOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:49:12 -0400
Message-ID: <502D0859.2000602@gmail.com>
Date: Thu, 16 Aug 2012 21:48:57 +0700
From: Maxim Nikulin <m.a.nikulin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120330 Icedove/10.0.3
MIME-Version: 1.0
To: trivial@kernel.org
CC: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH][TRIVIAL] platform/x86: fix asus_laptop.wled_type description
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


MODULE_PARM_DESC for wlan_status is further in the same file

Signed-off-by: Maxim A. Nikulin <M.A.Nikulin@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index e38f91b..f5b9d91 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -85,7 +85,7 @@ static char *wled_type = "unknown";
 static char *bled_type = "unknown";
 
 module_param(wled_type, charp, 0444);
-MODULE_PARM_DESC(wlan_status, "Set the wled type on boot "
+MODULE_PARM_DESC(wled_type, "Set the wled type on boot "
                 "(unknown, led or rfkill). "
                 "default is unknown");
 
-- 
1.7.2.5
