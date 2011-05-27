Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab1E0ES5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 00:18:57 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:45864 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1E0ESz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 00:18:55 -0400
Message-ID: <4DDF2628.8060200@freemail.hu>
Date: Fri, 27 May 2011 06:18:48 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>, Arnd Bergmann <arnd@arndb.de>
CC: usbip-devel@lists.sourceforge.net, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usbip: remove extra whitespace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.98.242
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Only one whitespace is enough after "return".

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
index d9736f9..ecd52b6 100644
--- a/drivers/staging/usbip/vhci_sysfs.c
+++ b/drivers/staging/usbip/vhci_sysfs.c
@@ -192,7 +192,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 	/* check sockfd */
 	socket = sockfd_to_socket(sockfd);
 	if (!socket)
-		return  -EINVAL;
+		return -EINVAL;

 	/* now need lock until setting vdev status as used */


