Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab0IIWhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:37:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50159 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab0IIWhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OCfGm4zJ2NV62QwTiExrFDTZk5XmDJ78yhotPmz8R5OMraNTUoVu2EJK07dGO9C58O
         bZhLBvNEBV/ic5dCsDiWvQLfkzDMkFfoiFdaEopyzol776pOknG/yu8j+/xy/k9mFYBQ
         eAsAnR56OiWkNUiw49LFtcvduj5Z9rjQzJdUw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 129/223]drivers/scsi/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:36 -0700
Message-Id: <1284071862-8194-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index bbf91ae..6fe68d0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -116,7 +116,7 @@ config CHR_DEV_OSST
 	  <http://www.tldp.org/docs.html#howto>  and
 	  <file:Documentation/scsi/osst.txt>  in the kernel source.
 	  More info on the OnStream driver may be found on
-	  <http://linux1.onstream.nl/test/>
+	  <http://web.archive.org/web/*/http://linux1.onstream.nl/test/>
 	  Please also have a look at the standard st docu, as most of it
 	  applies to osst as well.
 
@@ -156,9 +156,9 @@ config CHR_DEV_SG
 	  directly, so you need some additional software which knows how to
 	  talk to these devices using the SCSI protocol:
 
-	  For scanners, look at SANE (<http://www.mostang.com/sane/>). For CD
+	  For scanners, look at SANE (<http://www.sane-project.org/>). For CD
 	  writer software look at Cdrtools
-	  (<http://www.fokus.gmd.de/research/cc/glone/employees/joerg.schilling/private/cdrecord.html>)
+	  (<http://cdrecord.berlios.de/private/cdrecord.html>)
 	  and for burning a "disk at once": CDRDAO
 	  (<http://cdrdao.sourceforge.net/>). Cdparanoia is a high
 	  quality digital reader of audio CDs (<http://www.xiph.org/paranoia/>).
@@ -949,7 +949,7 @@ config SCSI_IPS
 	depends on PCI && SCSI
 	---help---
 	  This is support for the IBM ServeRAID hardware RAID controllers.
-	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
+	  See <http://www.ibm.com/us/en/>
 	  for more information.  If this driver does not work correctly
 	  without modification please contact the author by email at
 	  <ipslinux@adaptec.com>.
@@ -1608,9 +1608,9 @@ config SCSI_DEBUG
 	  each with multiple dummy SCSI devices (disks). It defaults to one
 	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
 	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
-	  dummy disks are simulated, they share the same kernel RAM for 
-	  their storage. See <http://www.torque.net/sg/sdebug.html> for more
-	  information. This driver is primarily of use to those testing the
+	  dummy disks are simulated, they share the same kernel RAM for their 
+	  storage. See <http://web.archive.org/web/*/http://www.torque.net/sg/sdebug.html> 
+	  for more information. This driver is primarily of use to those testing the
 	  SCSI and block subsystems. If unsure, say N.
 
 config SCSI_MESH
-- 
1.7.2.1

