Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1ALAk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:40:59 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:49681 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab1ALAk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:40:58 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1294792856!6574772!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 11 Jan 2011 18:37:25 -0600
Subject: [PATCH] mtdcore.c: local symbols should be static
Thread-Topic: [PATCH] mtdcore.c: local symbols should be static
Thread-Index: Acux8OHwRS3A5lgNRACaCmVqBKcrXA==
Message-ID: <0D753D10438DA54287A00B027084269764CE0E54FC@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0C0fKVA022944

The three backing_dev_info symbols are only used in this file and
should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 527cebf..da69bc8 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -43,7 +43,7 @@
  * backing device capabilities for non-mappable devices (such as NAND flash)
  * - permits private mappings, copies are taken of the data
  */
-struct backing_dev_info mtd_bdi_unmappable = {
+static struct backing_dev_info mtd_bdi_unmappable = {
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
 
@@ -52,7 +52,7 @@ struct backing_dev_info mtd_bdi_unmappable = {
  * - permits private mappings, copies are taken of the data
  * - permits non-writable shared mappings
  */
-struct backing_dev_info mtd_bdi_ro_mappable = {
+static struct backing_dev_info mtd_bdi_ro_mappable = {
 	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
 };
@@ -62,7 +62,7 @@ struct backing_dev_info mtd_bdi_ro_mappable = {
  * - permits private mappings, copies are taken of the data
  * - permits non-writable shared mappings
  */
-struct backing_dev_info mtd_bdi_rw_mappable = {
+static struct backing_dev_info mtd_bdi_rw_mappable = {
 	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
 			   BDI_CAP_WRITE_MAP),

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
