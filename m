Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2FETK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:10:58 -0400
Received: from [195.46.254.69] ([195.46.254.69]:29427 "EHLO
	extserver1.prnet.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2FETK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:10:57 -0400
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2012 15:10:57 EDT
Message-ID: <4FCE574F.7070007@prnet.org>
Date: Tue, 05 Jun 2012 21:00:31 +0200
From: David Arendt <admin@prnet.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120529 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] lpfc_scsi.c: remove unused variables (fixes compilation with
 -Werror)
Content-Type: multipart/mixed;
 boundary="------------020806050605060408020900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020806050605060408020900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

here is a patch to fix lpfc_scsi.c compilation on kernel 3.4 / 3.4.1

Bye,
David Arendt

--------------020806050605060408020900
Content-Type: text/plain; charset=us-ascii;
 name="lpfc_scsi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lpfc_scsi.patch"

diff -ur linux-3.4.1.orig/drivers/scsi/lpfc/lpfc_scsi.c linux-3.4.1/drivers/scsi/lpfc/lpfc_scsi.c
--- linux-3.4.1.orig/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-01 09:18:44.000000000 +0200
+++ linux-3.4.1/drivers/scsi/lpfc/lpfc_scsi.c	2012-06-05 20:24:43.157289036 +0200
@@ -1897,7 +1897,6 @@
 	dma_addr_t physaddr;
 	int i = 0, num_bde = 0, status;
 	int datadir = sc->sc_data_direction;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t reftag;
 	unsigned blksize;
@@ -2034,7 +2033,6 @@
 	int datadir = sc->sc_data_direction;
 	unsigned char pgdone = 0, alldone = 0;
 	unsigned blksize;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t reftag;
 	uint8_t txop, rxop;
@@ -2253,7 +2251,6 @@
 	uint32_t reftag;
 	unsigned blksize;
 	uint8_t txop, rxop;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
@@ -2383,7 +2380,6 @@
 	uint32_t reftag;
 	uint8_t txop, rxop;
 	uint32_t dma_len;
-	uint32_t rc;
 	uint32_t checking = 1;
 	uint32_t dma_offset = 0;
 	int num_sge = 0;

--------------020806050605060408020900--
