Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0FRHj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 03:39:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48974 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab0FRHjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 03:39:55 -0400
Reply-To: <nick.cheng@areca.com.tw>
From: "Nick Cheng" <nick.cheng@areca.com.tw>
To: <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <linux-kernel@vger.kernel.org>
References: 
Subject: [PATCH 3/3 ] SCSI: Remove the AER section in kconfig file
Date: Fri, 18 Jun 2010 15:39:48 +0800
Organization: Areca Technology
Message-ID: <6F6F4FA10B6F48AD96B4CC8CAABB4963@areca4e4f859d4>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0006_01CB0EFC.7EEED580"
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acowc/JWqUJly33gTDCpllU+Tsu/7SPlji1QBeB6xMAE6weakA==
In-Reply-To: 
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0006_01CB0EFC.7EEED580
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

1. Remove the AER section of Areca driver in kconfig file of scsi folder
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---

------=_NextPart_000_0006_01CB0EFC.7EEED580
Content-Type: application/octet-stream;
	name="patch_kconfig"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch_kconfig"

diff -Naurp --ignore-blank-lines --ignore-all-space =
--ignore-space-change a/linux/drivers/scsi/Kconfig =
b/linux/drivers/scsi/Kconfig=0A=
--- a/linux/drivers/scsi/Kconfig	2010-06-18 22:33:19.000000000 +0800=0A=
+++ b/linux/drivers/scsi/Kconfig	2010-06-18 23:24:54.000000000 +0800=0A=
@@ -585,32 +585,18 @@ config SCSI_IN2000=0A=
 	  module will be called in2000.=0A=
 =0A=
 config SCSI_ARCMSR=0A=
-	tristate "ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Adapter"=0A=
+	tristate "ARECA (ARC11xx/12xx/16xx/18xx) SATA/SAS RAID Host Adapter"=0A=
 	depends on PCI && SCSI=0A=
 	help=0A=
 	  This driver supports all of ARECA's SATA/SAS RAID controller cards.=0A=
-	  This is an ARECA-maintained driver by Erich Chen.=0A=
-	  If you have any problems, please mail to: <erich@areca.com.tw>.=0A=
+	  This is an ARECA-maintained driver by Nick Cheng.=0A=
+	  If you have any problems, please mail to: <support@areca.com.tw>.=0A=
 	  Areca supports Linux RAID config tools.=0A=
 	  Please link <http://www.areca.com.tw>=0A=
 =0A=
 	  To compile this driver as a module, choose M here: the=0A=
 	  module will be called arcmsr (modprobe arcmsr).=0A=
 =0A=
-config SCSI_ARCMSR_AER=0A=
-	bool "Enable PCI Error Recovery Capability in Areca Driver(ARCMSR)"=0A=
-	depends on SCSI_ARCMSR && PCIEAER=0A=
-	default n=0A=
-	help=0A=
-	  The advanced error reporting(AER) capability is "NOT" provided by=0A=
-	  ARC1200/1201/1202 SATA RAID controllers cards.=0A=
-	  If your card is one of ARC1200/1201/1202, please use the default =
setting, n.=0A=
-	  If your card is other models, you could pick it=0A=
-	  on condition that the kernel version is greater than 2.6.19.=0A=
-	  This function is maintained driver by Nick Cheng. If you have any=0A=
-	  problems or suggestion, you are welcome to contact with =
<nick.cheng@areca.com.tw>.=0A=
-	  To enable this function, choose Y here.=0A=
-=0A=
 source "drivers/scsi/megaraid/Kconfig.megaraid"=0A=
 source "drivers/scsi/mpt2sas/Kconfig"=0A=
 =0A=

------=_NextPart_000_0006_01CB0EFC.7EEED580--

