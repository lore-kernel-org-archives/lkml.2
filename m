Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab0EZSve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:51:34 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:44743 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757667Ab0EZSvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:51:32 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net EB11035A789
Subject: [PATCH 2/3] HID: Fixed warning of checkpatch.pl in roccat char
 device header
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linux-doc@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 20:51:28 +0200
Message-ID: <1274899888.9492.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warning of checkpatch.pl:
WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-roccat.h b/drivers/hid/hid-roccat.h
index d8aae0c..09e864e 100644
--- a/drivers/hid/hid-roccat.h
+++ b/drivers/hid/hid-roccat.h
@@ -15,7 +15,7 @@
 #include <linux/hid.h>
 #include <linux/types.h>
 
-#if defined(CONFIG_HID_ROCCAT) || defined (CONFIG_HID_ROCCAT_MODULE)
+#if defined(CONFIG_HID_ROCCAT) || defined(CONFIG_HID_ROCCAT_MODULE)
 int roccat_connect(struct hid_device *hid);
 void roccat_disconnect(int minor);
 int roccat_report_event(int minor, u8 const *data, int len);
-- 
1.6.6.1



