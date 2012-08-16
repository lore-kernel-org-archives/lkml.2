Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2HPAbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:31:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:32496 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2HPAbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:31:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1345077096!21706632!12
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] staging: comedi: contec_pci_dio: remove unused fields in the boardinfo
Date: Wed, 15 Aug 2012 17:31:12 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208151731.12974.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The model, in_ports, out_ports, and out_boffs information in the
boardinfo is not used by the driver. Remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/contec_pci_dio.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 387dd42..24427ca 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -42,15 +42,11 @@ enum contec_model {
 
 struct contec_board {
 	const char *name;
-	int model;
-	int in_ports;
-	int out_ports;
 	int in_offs;
 	int out_offs;
-	int out_boffs;
 };
 static const struct contec_board contec_boards[] = {
-	{"PIO1616L", PIO1616L, 16, 16, 0, 2, 10},
+	{"PIO1616L", 0, 2 },
 };
 
 #define PCI_DEVICE_ID_PIO1616L 0x8172
-- 
1.7.11

