Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0EQDZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:25:31 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:47250 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0EQDZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:25:26 -0400
Reply-To: <nick.cheng@areca.com.tw>
From: "Nick Cheng" <nick.cheng@areca.com.tw>
To: <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <linux-kernel@vger.kernel.org>
References: 
Subject: [PATCH 4/4 ] SCSI: Remove the AER section in kconfig file
Date: Mon, 17 May 2010 11:25:14 +0800
Organization: Areca Technology
Message-ID: <73CF625FE7264E698A105A7914FC0396@areca4e4f859d4>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001E_01CAF5B3.A2B9FF10"
X-Mailer: Microsoft Office Outlook 11
thread-index: Acowc/JWqUJly33gTDCpllU+Tsu/7SPlji1QBeB6xMAE6weakA==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_001E_01CAF5B3.A2B9FF10
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

1. Remove the AER section of Areca driver in kconfig file of scsi folder
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---

------=_NextPart_000_001E_01CAF5B3.A2B9FF10
Content-Type: application/octet-stream;
	name="patch_kconfig"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch_kconfig"

--- linux-2.6/drivers/scsi/Kconfig	2010-02-25 02:52:17.000000000 +0800=0A=
+++ linux-2.6/drivers/scsi/Kconfig.new	2010-05-05 10:55:26.000000000 =
+0800=0A=
@@ -579,32 +579,18 @@ config SCSI_IN2000=0A=
 	  module will be called in2000.=0A=
 =0A=
 config SCSI_ARCMSR=0A=
-	tristate "ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Adapter"=0A=
+	tristate "ARECA (ARC11xx/12xx/13xx/16xx/18XX) SATA/SAS RAID Host =
Adapter"=0A=
 	depends on PCI && SCSI=0A=
 	help=0A=
 	  This driver supports all of ARECA's SATA/SAS RAID controller cards.=0A=
-	  This is an ARECA-maintained driver by Erich Chen.=0A=
-	  If you have any problems, please mail to: <erich@areca.com.tw>.=0A=
+	  This is an ARECA-maintained driver by Nick Cheng.=0A=
+	  If you have any problems, please mail to: <nick.cheng@areca.com.tw>.=0A=
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

------=_NextPart_000_001E_01CAF5B3.A2B9FF10--

