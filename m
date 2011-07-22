Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1GVAB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 20:01:26 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:41560 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751607Ab1GVABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 20:01:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JbYAYMXejAt7GWHf9rBrnHn2hPdoaXC8zdypQKqXq5pbjobEj7jwdEv7ccYAhaonbmoTPZ0NVrdwH8SBv7tX90Pm5O/zI9+j6b//MYUH0mkAFqlHaRSSREY3VNrE4iJX;
Date: Thu, 21 Jul 2011 17:01:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] firmware: sigma.c needs MODULE_LICENSE
Message-Id: <20110721170122.1fd4a06e.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix module tainting message:
sigma: module license 'unspecified' taints kernel.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 drivers/firmware/sigma.c |    3 +++
 1 file changed, 3 insertions(+)

--- lnx-30-rc7.orig/drivers/firmware/sigma.c
+++ lnx-30-rc7/drivers/firmware/sigma.c
@@ -11,6 +11,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/sigma.h>
 
 /* Return: 0==OK, <0==error, =1 ==no more actions */
@@ -113,3 +114,5 @@ int process_sigma_firmware(struct i2c_cl
 	return ret;
 }
 EXPORT_SYMBOL(process_sigma_firmware);
+
+MODULE_LICENSE("GPL");
