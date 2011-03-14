Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab1CNUnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:43:14 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:42697 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756297Ab1CNUnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:43:12 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 01A0A5A3C3
Subject: [PATCH] HID: roccat: Corrected mode of sysfs attr 'sensor' from
 koneplus driver
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 21:43:07 +0100
Message-ID: <1300135387.7466.0.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mode of sysfs attribute 'sensor' was wrongly set to writeonly.
Corrected this to readwrite.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-koneplus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index a8e2117..33eec74 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -460,7 +460,7 @@ static struct device_attribute koneplus_attributes[] = {
 
 static struct bin_attribute koneplus_bin_attributes[] = {
 	{
-		.attr = { .name = "sensor", .mode = 0220 },
+		.attr = { .name = "sensor", .mode = 0660 },
 		.size = sizeof(struct koneplus_sensor),
 		.read = koneplus_sysfs_read_sensor,
 		.write = koneplus_sysfs_write_sensor
-- 
1.7.3.4



