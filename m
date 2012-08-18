Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2HRBU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:20:26 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:3201 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab2HRBUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:20:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1345252820!7251295!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/20] staging: comedi: adv_pci_dio: remove '0' boardinfo data
Date: Fri, 17 Aug 2012 18:20:14 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171820.15182.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the boardinfo data that is simply '0'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c | 84 ----------------------------
 1 file changed, 84 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 0d1b441..e535d31 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -260,10 +260,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.sdi[1]		= { 16, PCI1730_IDI, 2, 0, },
 		.sdo[0]		= { 16, PCI1730_DO, 2, 0, },
 		.sdo[1]		= { 16, PCI1730_IDO, 2, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI173x_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1733",
@@ -271,14 +268,8 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1733,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1733,
-		.sdi[0]		= { 0, 0, 0, 0, },
 		.sdi[1]		= { 32, PCI1733_IDI, 4, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI173x_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1734",
@@ -286,14 +277,8 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1734,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1734,
-		.sdi[0]		= { 0, 0, 0, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
 		.sdo[1]		= { 32, PCI1734_IDO, 4, 0, },
-		.sdio[0]	= { 0, 0, 0, 0 },
-		.sdio[1]	= { 0, 0, 0, 0 },
 		.boardid	= { 4, PCI173x_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1735",
@@ -302,11 +287,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1735,
 		.sdi[0]		= { 32, PCI1735_DI, 4, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
 		.sdo[0]		= { 32, PCI1735_DO, 4, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI1735_BOARDID, 1, SDF_INTERNAL, },
 		.s8254[0]	= { 3, PCI1735_C8254, 1, 0, },
 		.io_access	= IO_8b,
@@ -316,14 +297,9 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1736,
 		.main_pci_region = PCI1736_MAINREG,
 		.cardtype	= TYPE_PCI1736,
-		.sdi[0]		= { 0, 0, 0, 0, },
 		.sdi[1]		= { 16, PCI1736_IDI, 2, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
 		.sdo[1]		= { 16, PCI1736_IDO, 2, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI1736_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1739",
@@ -331,14 +307,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1739,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1739,
-		.sdi[0]		= { 0, 0, 0, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
 		.sdio[0]	= { 48, PCI1739_DIO, 2, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
-		.boardid	= { 0, 0, 0, 0, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1750",
@@ -346,14 +315,8 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1750,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1750,
-		.sdi[0]		= { 0, 0, 0, 0,},
 		.sdi[1]		= { 16, PCI1750_IDI, 2, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
 		.sdo[1]		= { 16, PCI1750_IDO, 2, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
-		.boardid	= { 0, 0, 0, 0, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1751",
@@ -361,13 +324,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1751,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1751,
-		.sdi[0]		= { 0, 0, 0, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
 		.sdio[0]	= { 48, PCI1751_DIO, 2, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
-		.boardid	= { 0, 0, 0, 0, },
 		.s8254[0]	= { 3, PCI1751_CNT, 1, 0, },
 		.io_access	= IO_8b,
 	}, {
@@ -376,14 +333,9 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1752,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1752,
-		.sdi[0]		= { 0, 0, 0, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
 		.sdo[0]		= { 32, PCI1752_IDO, 2, 0, },
 		.sdo[1]		= { 32, PCI1752_IDO2, 2, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI175x_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_16b,
 	}, {
 		.name		= "pci1753",
@@ -391,14 +343,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1753,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1753,
-		.sdi[0]		= { 0, 0, 0, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
 		.sdio[0]	= { 96, PCI1753_DIO, 4, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
-		.boardid	= { 0, 0, 0, 0, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1753e",
@@ -406,14 +351,8 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1753,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1753E,
-		.sdi[0]		= { 0, 0, 0, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
 		.sdio[0]	= { 96, PCI1753_DIO, 4, 0, },
 		.sdio[1]	= { 96, PCI1753E_DIO, 4, 0, },
-		.boardid	= { 0, 0, 0, 0, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1754",
@@ -423,12 +362,7 @@ static const struct dio_boardtype boardtypes[] = {
 		.cardtype	= TYPE_PCI1754,
 		.sdi[0]		= { 32, PCI1754_IDI, 2, 0, },
 		.sdi[1]		= { 32, PCI1754_IDI2, 2, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI175x_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_16b,
 	}, {
 		.name		= "pci1756",
@@ -436,14 +370,9 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1756,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1756,
-		.sdi[0]		= { 0, 0, 0, 0,},
 		.sdi[1]		= { 32, PCI1756_IDI, 2, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
 		.sdo[1]		= { 32, PCI1756_IDO, 2, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI175x_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_16b,
 	}, {
 		/* This card has its own 'attach' */
@@ -452,14 +381,6 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1760,
 		.main_pci_region = 0,
 		.cardtype	= TYPE_PCI1760,
-		.sdi[0]		= { 0, 0, 0, 0, },
-		.sdi[1]		= { 0, 0, 0, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
-		.sdo[1]		= { 0, 0, 0, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
-		.boardid	= { 0, 0, 0, 0, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_8b,
 	}, {
 		.name		= "pci1762",
@@ -467,14 +388,9 @@ static const struct dio_boardtype boardtypes[] = {
 		.device_id	= 0x1762,
 		.main_pci_region = PCIDIO_MAINREG,
 		.cardtype	= TYPE_PCI1762,
-		.sdi[0]		= { 0, 0, 0, 0,},
 		.sdi[1]		= { 16, PCI1762_IDI, 1, 0, },
-		.sdo[0]		= { 0, 0, 0, 0, },
 		.sdo[1]		= { 16, PCI1762_RO, 1, 0, },
-		.sdio[0]	= { 0, 0, 0, 0, },
-		.sdio[1]	= { 0, 0, 0, 0, },
 		.boardid	= { 4, PCI1762_BOARDID, 1, SDF_INTERNAL, },
-		.s8254[0]	= { 0, 0, 0, 0, },
 		.io_access	= IO_16b,
 	},
 };
-- 
1.7.11

