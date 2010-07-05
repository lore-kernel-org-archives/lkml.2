Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab0GEJVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:21:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52484 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210Ab0GEJVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qAkWsyUpY2jlG32WBw2vN5WmyDn7Ttd2mXEkvDIqBkPMPTZNTlcxyJQSSR+Rqgq+YV
         wHRW6XAuypCPVngp8GrbYzPafppa7zyy5CemUYKgk9xIAPYklBq57+VQWYTYLJDqmah9
         BgFsF7ctxrMMGue1MqLnwZ+e7+Q0ZlngFuUuk=
Subject: [PATCH] dell-laptop: make dell_laptop_i8042_filter() static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Mario Limonciello <superm1@ubuntu.com>,
       Stuart Hayes <stuart_hayes@dell.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Mon, 05 Jul 2010 17:21:10 +0800
Message-Id: <1278321670.12801.12.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make dell_laptop_i8042_filter() static as it's used only in dell-laptop.c

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/dell-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 661e3ac..dbbcaa6 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -467,7 +467,7 @@ static struct backlight_ops dell_ops = {
 	.update_status  = dell_send_intensity,
 };
 
-bool dell_laptop_i8042_filter(unsigned char data, unsigned char str,
+static bool dell_laptop_i8042_filter(unsigned char data, unsigned char str,
 			      struct serio *port)
 {
 	static bool extended;
-- 
1.5.4.3



