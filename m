Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab0KZT5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:57:40 -0500
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:41417 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596Ab0KZT5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:57:38 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net CED185A0EF
Subject: [PATCH 3/5] HID: roccat: declaring meaning of pack pragma usage in
 driver headers
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 20:57:36 +0100
Message-ID: <1290801456.18750.164.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using pack pragma to prevent padding bytes in binary data structures
used for hardware communication. Explanation of these pragmas was requested.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.h |    3 +++
 drivers/hid/hid-roccat-pyra.h |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.h b/drivers/hid/hid-roccat-kone.h
index 130d656..11203a7 100644
--- a/drivers/hid/hid-roccat-kone.h
+++ b/drivers/hid/hid-roccat-kone.h
@@ -14,6 +14,9 @@
 
 #include <linux/types.h>
 
+/*
+ * Binary data structures used for hardware communication must have no padding.
+ */
 #pragma pack(push)
 #pragma pack(1)
 
diff --git a/drivers/hid/hid-roccat-pyra.h b/drivers/hid/hid-roccat-pyra.h
index 22f80a8..ac5996e 100644
--- a/drivers/hid/hid-roccat-pyra.h
+++ b/drivers/hid/hid-roccat-pyra.h
@@ -14,6 +14,9 @@
 
 #include <linux/types.h>
 
+/*
+ * Binary data structures used for hardware communication must have no padding.
+ */
 #pragma pack(push)
 #pragma pack(1)
 
-- 
1.7.2.3



