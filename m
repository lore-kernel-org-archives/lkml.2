Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0I1QgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:36:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52485 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab0I1QgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=tttC+55xCD1u28otrCW/jvKatTwrjLg246xH6h41XfH2DXR3Ik20+NYjTisuDZCt+A
         924GJzmN7dADxkYd2FKlkUYBxGx6MtdTCLiNB0e19a9GCAG6PE3YmtxfPzAma1fCbNa0
         UI0rC5zfFYVB/Z6F8hPfvaTu/IVBnVdxKF5kw=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, stewart_r@aliencamel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] Staging: comedi: fix EXPORT SYMBOL coding style issue in ni_labpc.c
Date: Tue, 28 Sep 2010 17:35:53 +0100
Message-Id: <1285691753-4391-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc.c file that fixes up, EXPORT SYMBOL(foo) should immediately follow its function/variable
 warnings, found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index bfce5c8..0f61bb1 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -345,6 +345,7 @@ const int labpc_1200_is_unipolar[NUM_LABPC_1200_AI_RANGES] = {
 	1,
 	1,
 };
+EXPORT_SYMBOL_GPL(labpc_1200_is_unipolar);
 
 /* map range index to gain bits */
 const int labpc_1200_ai_gain_bits[NUM_LABPC_1200_AI_RANGES] = {
@@ -363,6 +364,7 @@ const int labpc_1200_ai_gain_bits[NUM_LABPC_1200_AI_RANGES] = {
 	0x60,
 	0x70,
 };
+EXPORT_SYMBOL_GPL(labpc_1200_ai_gain_bits);
 
 const struct comedi_lrange range_labpc_1200_ai = {
 	NUM_LABPC_1200_AI_RANGES,
@@ -383,6 +385,7 @@ const struct comedi_lrange range_labpc_1200_ai = {
 	 UNI_RANGE(0.1),
 	 }
 };
+EXPORT_SYMBOL_GPL(range_labpc_1200_ai);
 
 /* analog output ranges */
 #define AO_RANGE_IS_UNIPOLAR 0x1
@@ -701,6 +704,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(labpc_common_attach);
 
 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
@@ -807,6 +811,7 @@ int labpc_common_detach(struct comedi_device *dev)
 
 	return 0;
 };
+EXPORT_SYMBOL_GPL(labpc_common_detach);
 
 static void labpc_clear_adc_fifo(const struct comedi_device *dev)
 {
@@ -2152,11 +2157,6 @@ module_init(driver_labpc_init_module);
 module_exit(driver_labpc_cleanup_module);
 #endif
 
-EXPORT_SYMBOL_GPL(labpc_common_attach);
-EXPORT_SYMBOL_GPL(labpc_common_detach);
-EXPORT_SYMBOL_GPL(range_labpc_1200_ai);
-EXPORT_SYMBOL_GPL(labpc_1200_ai_gain_bits);
-EXPORT_SYMBOL_GPL(labpc_1200_is_unipolar);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
-- 
1.7.0.4

