Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0CWTd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:33:57 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:40170 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0CWTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=vpAYb+MgpVhbr20BrLq8340ZcSHVhU81hRaz9cyKoi+cCo+LPPe5qqzB4MiK+Sr7Qi
         fKsVzRxotG9OtM8RtTQk6mac5NHoCIiEHEEi04vs5IoMwVMLL9WCam6LlWer81RWWY6f
         i23lExmfnmLO5wL0nwA3R43uUmIBha8nhEejc=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/21] Staging: comedi: fix indent coding style issue in adq12b.c
Date: Tue, 23 Mar 2010 19:33:38 +0000
Message-Id: <1269372818-3437-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adq12b.c file that fixes up an indent warning found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adq12b.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index c5ed8bb..b51813b 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -42,25 +42,25 @@ If you do not specify any options, they will default to
   option 1: I/O base address. The following table is provided as a help
    of the hardware jumpers.
 
-         address            jumper JADR
-          0x300                 1 (factory default)
-          0x320                 2
-          0x340                 3
-          0x360                 4
-          0x380                 5
-          0x3A0                 6
+	address			jumper JADR
+	0x300			1 (factory default)
+	0x320			2
+	0x340			3
+	0x360			4
+	0x380			5
+	0x3A0			6
 
   option 2: unipolar/bipolar ADC selection: 0 -> bipolar, 1 -> unipolar
 
-        selection         comedi_config option            JUB
-         bipolar                0                         2-3 (factory default)
-         unipolar               1                         1-2
+	selection	comedi_config option	JUB
+	bipolar			0		2-3 (factory default)
+	unipolar		1		1-2
 
   option 3: single-ended/differential AI selection: 0 -> SE, 1 -> differential
 
-        selection         comedi_config option     JCHA    JCHB
-       single-ended             0                  1-2     1-2 (factory default)
-       differential             1                  2-3     2-3
+	selection	comedi_config option	JCHA	JCHB
+	single-ended		0		1-2	1-2 (factory default)
+	differential		1		2-3	2-3
 
    written by jeremy theler <thelerg@ib.cnea.gov.ar>
 
@@ -140,7 +140,7 @@ static const struct adq12b_board adq12b_boards[] = {
 	.ai_bits = 12,
 	.di_chans = 8,
 	.do_chans = 5
-        }*/
+	}*/
 };
 
 #define thisboard ((const struct adq12b_board *)dev->board_ptr)
-- 
1.6.3.3

