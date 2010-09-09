Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab0IIWez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:34:55 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57142 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725Ab0IIWex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:34:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Quio9g61sdOgFDZx/TRonqLvqtUk04sb7qwuNT5pH9ay4JeWwaE0rTh8Kjsad1CSj6
         Vcb8Lf7+GPCAd/H1RMuLc4yTxy60DkGsdJzUSYj429B7g5CpLu6FLsRjHAWp3wwB5OyS
         HT7q2JYMJWtwxH+A/77qzJe+MSRxI/wjiAXwU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 105/223]drivers/net/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:35:03 -0700
Message-Id: <1284071703-7996-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071703-7996-1-git-send-email-justinmattock@gmail.com>
References: <1284071703-7996-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/Kconfig |   37 +++++++++++++++----------------------
 1 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 2cc81a5..a026fd7 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -169,9 +169,7 @@ config NET_SB1000
 	  a connection. Further documentation and the necessary scripts can be
 	  found at:
 
-	  <http://www.jacksonville.net/~fventuri/>
-	  <http://home.adelphia.net/~siglercm/sb1000.html>
-	  <http://linuxpower.cx/~cable/>
+	  <http://web.archive.org/web/*/http://www.jacksonville.net/~fventuri/>
 
 	  If you don't have this card, of course say N.
 
@@ -921,7 +919,7 @@ config SMC91X
 	  including the SMC91C94 and the SMC91C111. Say Y if you want it
 	  compiled into the kernel, and read the file
 	  <file:Documentation/networking/smc9.txt>  and the Ethernet-HOWTO,
-	  available from  <http://www.linuxdoc.org/docs.html#howto>.
+	  available from  <http://www.tldp.org/docs.html#howto>.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want).
@@ -1031,7 +1029,7 @@ config SMC911X
 	  including the new LAN9115, LAN9116, LAN9117, and LAN9118.
 	  Say Y if you want it compiled into the kernel, 
 	  and read the Ethernet-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://www.tldp.org/docs.html#howto>.
 
 	  This driver is also available as a module. The module will be 
 	  called smc911x.  If you want to compile it as a module, say M 
@@ -1511,10 +1509,6 @@ config E100
 
           to identify the adapter.
 
-	  For the latest Intel PRO/100 network driver for Linux, see:
-
-	  <http://appsr.intel.com/scripts-df/support_intel.asp>
-
 	  More specific information on configuring the driver is in 
 	  <file:Documentation/networking/e100.txt>.
 
@@ -1541,7 +1535,7 @@ config FEALNX
 	help
 	  Say Y here to support the Mysom MTD-800 family of PCI-based Ethernet
 	  cards. Specifications and data at
-	  <http://www.myson.com.hk/mtd/datasheet/>.
+	  <http://www.datasheetarchive.com/datasheet-pdf/022/DSA00384882.html>.
 
 config NATSEMI
 	tristate "National Semiconductor DP8381x series PCI Ethernet support"
@@ -1552,7 +1546,7 @@ config NATSEMI
 	  which is used in cards from PureData, NetGear, Linksys
 	  and others, including the 83815 chip.
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/natsemi.html>.
+	  <http://www.penguincomputing.com/>.
 
 config NE2K_PCI
 	tristate "PCI NE2000 and clones support (see help)"
@@ -1703,7 +1697,7 @@ config EPIC100
 	  This driver is for the SMC EtherPower II 9432 PCI Ethernet NIC,
 	  which is based on the SMC83c17x (EPIC/100).
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/epic100.html>.
+	  <http://www.penguincomputing.com/>.
 
 config SMSC9420
 	tristate "SMSC LAN9420 PCI ethernet adapter support"
@@ -1715,7 +1709,7 @@ config SMSC9420
 	  This is a driver for SMSC's LAN9420 PCI ethernet adapter.
 	  Say Y if you want it compiled into the kernel,
 	  and read the Ethernet-HOWTO, available from
-	  <http://www.linuxdoc.org/docs.html#howto>.
+	  <http://www.tldp.org/docs.html#howto>.
 
 	  This driver is also available as a module. The module will be
 	  called smsc9420.  If you want to compile it as a module, say M
@@ -1729,7 +1723,7 @@ config SUNDANCE
 	help
 	  This driver is for the Sundance "Alta" chip.
 	  More specific information and updates are available from
-	  <http://www.scyld.com/network/sundance.html>.
+	  <http://www.penguincomputing.com/>.
 
 config SUNDANCE_MMIO
 	bool "Use MMIO instead of PIO"
@@ -2201,7 +2195,7 @@ config YELLOWFIN
 	  Say Y here if you have a Packet Engines G-NIC PCI Gigabit Ethernet
 	  adapter or the SYM53C885 Ethernet controller. The Gigabit adapter is
 	  used by the Beowulf Linux cluster project.  See
-	  <http://cesdis.gsfc.nasa.gov/linux/drivers/yellowfin.html> for more
+	  <http://www.beowulf.org/> for more
 	  information about this driver in particular and Beowulf in general.
 
 	  To compile this driver as a module, choose M here: the module
@@ -2550,7 +2544,7 @@ config CHELSIO_T1
           our website at <http://www.chelsio.com>.
 
           For customer support, please visit our customer support page at
-          <http://www.chelsio.com/support.htm>.
+          <http://www.chelsio.com/support.html>.
 
           Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -2582,7 +2576,7 @@ config CHELSIO_T3
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -2607,7 +2601,7 @@ config CHELSIO_T4
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -2630,7 +2624,7 @@ config CHELSIO_T4VF
 	  our website at <http://www.chelsio.com>.
 
 	  For customer support, please visit our customer support page at
-	  <http://www.chelsio.com/support.htm>.
+	  <http://www.chelsio.com/support.html>.
 
 	  Please send feedback to <linux-bugs@chelsio.com>.
 
@@ -3048,7 +3042,6 @@ config PLIP
 	  <file:Documentation/networking/PLIP.txt>.  The cables can be up to
 	  15m long.  Mode 0 works also if one of the machines runs DOS/Windows
 	  and has some PLIP software installed, e.g. the Crynwr PLIP packet
-	  driver (<http://oak.oakland.edu/simtel.net/msdos/pktdrvr-pre.html>)
 	  and winsock or NCSA's telnet.
 
 	  If you want to use PLIP, say Y and read the PLIP mini-HOWTO as well
@@ -3262,8 +3255,8 @@ config SLIP_COMPRESSED
 	  <ftp://ibiblio.org/pub/Linux/system/network/serial/>) which
 	  allows you to use SLIP over a regular dial up shell connection, you
 	  definitely want to say Y here. The NET-3-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>, explains how to configure
-	  CSLIP. This won't enlarge your kernel.
+	  <http://web.archive.org/web/*/http://www.bart.nl/~patrickr/term-howto/Term-HOWTO.html>,
+	  explains how to configure CSLIP. This won't enlarge your kernel.
 
 config SLHC
 	tristate
-- 
1.7.2.1

