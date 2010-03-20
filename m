Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab0CTFe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 01:34:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42316 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0CTFez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 01:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hrCEYaYhQWblq1pgiXs99l2qSBnPHvhCWK9DoZjQi9MzjggYChbHvDUAu1oU5mya1N
         JOSJDzel9pWWzegMxrGb51+6Msbk6f1BHKsa9qJG497TBwNjkI7fs+2Vg6LbJD9XXnj7
         KjGRneSmL56opeql+jRW9QYTYuKhkF2z2CD7E=
From: sai <tsg321@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sai <tsg321@gmail.com>
Subject: [PATCH] staging:cx25821:fixes coding styles in cx25821-i2c.c
Date: Sat, 20 Mar 2010 11:04:22 +0530
Message-Id: <1269063262-4268-1-git-send-email-tsg321@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sai <sai@sai-desktop.(none)>

This is a patch to the cx25821-i2c.c file that fixes warning and errors found by checkpatch.pl tool
Signed-off-by: sai<tsg321@gmail.com>
---
 drivers/staging/cx25821/cx25821-i2c.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index f4f2681..08f45b5 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -28,7 +28,7 @@ static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
 MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 
-static unsigned int i2c_scan = 0;
+static unsigned int i2c_scan;
 module_param(i2c_scan, int, 0444);
 MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
@@ -159,9 +159,9 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 
 	return msg->len;
 
-      eio:
+eio:
 	retval = -EIO;
-      err:
+err:
 	if (i2c_debug)
 		printk(KERN_ERR " ERR: %d\n", retval);
 	return retval;
@@ -223,9 +223,9 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 	}
 
 	return msg->len;
-      eio:
+eio:
 	retval = -EIO;
-      err:
+err:
 	if (i2c_debug)
 		printk(KERN_ERR " ERR: %d\n", retval);
 	return retval;
@@ -266,7 +266,7 @@ static int i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int num)
 	}
 	return num;
 
-      err:
+err:
 	return retval;
 }
 
@@ -319,7 +319,7 @@ int cx25821_i2c_register(struct cx25821_i2c *bus)
 
 	bus->i2c_client.adapter = &bus->i2c_adap;
 
-	//set up the I2c
+	/* set up the I2c */
 	bus->i2c_client.addr = (0x88 >> 1);
 
 	return bus->i2c_rc;
-- 
1.6.3.3

