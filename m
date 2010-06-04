Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0FDUuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:50:44 -0400
Received: from kroah.org ([198.145.64.141]:44008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab0FDUsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alexander Kurz <linux@kbdbabel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/11] serial_cs: add and sort IDs for serial and modem cards
Date: Fri,  4 Jun 2010 13:47:48 -0700
Message-Id: <1275684477-20172-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Kurz <linux@kbdbabel.org>

Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_cs.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/serial_cs.c b/drivers/serial/serial_cs.c
index dadd686..5263073 100644
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -715,6 +715,8 @@ static struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0057, 0x0021),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0089, 0x110a),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0104, 0x000a),
+	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0105, 0x0d0a),
+	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0105, 0x0e0a),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0105, 0xea15),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0109, 0x0501),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0138, 0x110a),
@@ -724,8 +726,6 @@ static struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x016c, 0x0081),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x021b, 0x0101),
 	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x08a1, 0xc0ab),
-	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0105, 0x0d0a),
-	PCMCIA_PFC_DEVICE_MANF_CARD(1, 0x0105, 0x0e0a),
 	PCMCIA_PFC_DEVICE_PROD_ID123(1, "MEGAHERTZ", "CC/XJEM3288", "DATA/FAX/CELL ETHERNET MODEM", 0xf510db04, 0x04cd2988, 0x46a52d63),
 	PCMCIA_PFC_DEVICE_PROD_ID123(1, "MEGAHERTZ", "CC/XJEM3336", "DATA/FAX/CELL ETHERNET MODEM", 0xf510db04, 0x0143b773, 0x46a52d63),
 	PCMCIA_PFC_DEVICE_PROD_ID123(1, "MEGAHERTZ", "EM1144T", "PCMCIA MODEM", 0xf510db04, 0x856d66c8, 0xbd6c43ef),
@@ -768,17 +768,26 @@ static struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x0276),
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0039),
 	PCMCIA_DEVICE_MANF_CARD(0x0104, 0x0006),
+	PCMCIA_DEVICE_MANF_CARD(0x0105, 0x0101), /* TDK DF2814 */
+	PCMCIA_DEVICE_MANF_CARD(0x0105, 0x100a), /* Xircom CM-56G */
+	PCMCIA_DEVICE_MANF_CARD(0x0105, 0x3e0a), /* TDK DF5660 */
 	PCMCIA_DEVICE_MANF_CARD(0x0105, 0x410a),
+	PCMCIA_DEVICE_MANF_CARD(0x0107, 0x0002), /* USRobotics 14,400 */
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x0d50),
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x0d51),
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x0d52),
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x0d53),
 	PCMCIA_DEVICE_MANF_CARD(0x010b, 0xd180),
+	PCMCIA_DEVICE_MANF_CARD(0x0115, 0x3330), /* USRobotics/SUN 14,400 */
+	PCMCIA_DEVICE_MANF_CARD(0x0124, 0x0100), /* Nokia DTP-2 ver II */
+	PCMCIA_DEVICE_MANF_CARD(0x0134, 0x5600), /* LASAT COMMUNICATIONS A/S */
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x000e),
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x001b),
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x0025),
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x0045),
 	PCMCIA_DEVICE_MANF_CARD(0x0137, 0x0052),
+	PCMCIA_DEVICE_MANF_CARD(0x016c, 0x0006), /* Psion 56K+Fax */
+	PCMCIA_DEVICE_MANF_CARD(0x0200, 0x0001), /* MultiMobile */
 	PCMCIA_DEVICE_PROD_ID134("ADV", "TECH", "COMpad-32/85", 0x67459937, 0x916d02ba, 0x8fbe92ae),
 	PCMCIA_DEVICE_PROD_ID124("GATEWAY2000", "CC3144", "PCMCIA MODEM", 0x506bccae, 0xcb3685f1, 0xbd6c43ef),
 	PCMCIA_DEVICE_PROD_ID14("MEGAHERTZ", "PCMCIA MODEM", 0xf510db04, 0xbd6c43ef),
@@ -792,16 +801,21 @@ static struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("COMPAQ", "PCMCIA 33600 FAX/DATA MODEM", 0xa3a3062c, 0x5a00ce95),
 	PCMCIA_DEVICE_PROD_ID12("Computerboards, Inc.", "PCM-COM422", 0xd0b78f51, 0x7e2d49ed),
 	PCMCIA_DEVICE_PROD_ID12("Dr. Neuhaus", "FURY CARD 14K4", 0x76942813, 0x8b96ce65),
+	PCMCIA_DEVICE_PROD_ID12("IBM", "ISDN/56K/GSM", 0xb569a6e5, 0xfee5297b),
 	PCMCIA_DEVICE_PROD_ID12("Intelligent", "ANGIA FAX/MODEM", 0xb496e65e, 0xf31602a6),
 	PCMCIA_DEVICE_PROD_ID12("Intel", "MODEM 2400+", 0x816cc815, 0x412729fb),
+	PCMCIA_DEVICE_PROD_ID12("Intertex", "IX34-PCMCIA", 0xf8a097e3, 0x97880447),
 	PCMCIA_DEVICE_PROD_ID12("IOTech Inc ", "PCMCIA Dual RS-232 Serial Port Card", 0x3bd2d898, 0x92abc92f),
 	PCMCIA_DEVICE_PROD_ID12("MACRONIX", "FAX/MODEM", 0x668388b3, 0x3f9bdf2f),
 	PCMCIA_DEVICE_PROD_ID12("Multi-Tech", "MT1432LT", 0x5f73be51, 0x0b3e2383),
 	PCMCIA_DEVICE_PROD_ID12("Multi-Tech", "MT2834LT", 0x5f73be51, 0x4cd7c09e),
 	PCMCIA_DEVICE_PROD_ID12("OEM      ", "C288MX     ", 0xb572d360, 0xd2385b7a),
+	PCMCIA_DEVICE_PROD_ID12("Option International", "V34bis GSM/PSTN Data/Fax Modem", 0x9d7cd6f5, 0x5cb8bf41),
 	PCMCIA_DEVICE_PROD_ID12("PCMCIA   ", "C336MX     ", 0x99bcafe9, 0xaa25bcab),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "PCMCIA Dual RS-232 Serial Port Card", 0xc4420b35, 0x92abc92f),
 	PCMCIA_DEVICE_PROD_ID12("Quatech Inc", "Dual RS-232 Serial Port PC Card", 0xc4420b35, 0x031a380d),
+	PCMCIA_DEVICE_PROD_ID12("Telia", "SurfinBird 560P/A+", 0xe2cdd5e, 0xc9314b38),
+	PCMCIA_DEVICE_PROD_ID1("Smart Serial Port", 0x2d8ce292),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "PCMCIA", "EN2218-LAN/MODEM", 0x281f1c5d, 0x570f348e, "cis/PCMLM28.cis"),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "PCMCIA", "UE2218-LAN/MODEM", 0x281f1c5d, 0x6fdcacee, "cis/PCMLM28.cis"),
 	PCMCIA_PFC_DEVICE_CIS_PROD_ID12(1, "Psion Dacom", "Gold Card V34 Ethernet", 0xf5f025c2, 0x338e8155, "cis/PCMLM28.cis"),
-- 
1.7.1

