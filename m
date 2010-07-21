Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105Ab0GUEyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:54:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35862 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab0GUExX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=f1zyGm0CTYNH77hWwnbjpiWFuVV65XM5ezNx7sbXFG+yzc1tWxSFkvm54qHQ1NY6ps
         cy9+rYcPOb5CfOx7n9vmS1FK/Ug9nk1u6RIkgk8ZtbZcYx0EeoS/gTXrxJiC+Ngkfnsu
         2fQ4u8mEqQbiEsImwFcuUTar6XL3tz2GG2uOk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 42/42]Documentation/hwmon/w83781d update wbe address.
Date: Tue, 20 Jul 2010 21:52:59 -0700
Message-Id: <1279687982-29413-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates the broken web address to the company
site due to me being unable to locate the original content.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/hwmon/w83781d |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/w83781d b/Documentation/hwmon/w83781d
index c91e0b6..ecbc1e4 100644
--- a/Documentation/hwmon/w83781d
+++ b/Documentation/hwmon/w83781d
@@ -9,7 +9,7 @@ Supported chips:
   * Winbond W83782D
     Prefix: 'w83782d'
     Addresses scanned: I2C 0x28 - 0x2f, ISA 0x290 (8 I/O ports)
-    Datasheet: http://www.winbond.com/PDF/sheet/w83782d.pdf
+    Datasheet: http://www.winbond.com
   * Winbond W83783S
     Prefix: 'w83783s'
     Addresses scanned: I2C 0x2d
-- 
1.7.1.rc1.21.gf3bd6

