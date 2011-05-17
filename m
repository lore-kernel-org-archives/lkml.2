Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1EQM0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:26:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42998 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab1EQM0g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:26:36 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1305635052.19966.142.camel@localhost>
References: <1305635052.19966.142.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 May 2011 13:26:26 +0100
Message-ID: <1305635186.19966.143.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH linux-firmware 1/3] Add source and copyright notice for CIS
 files from pcmcia-cs
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CIS files mostly come from pcmcia-cs releases, in which the source
files were named etc/cis/*.cis and the binaries were named
etc/cis/*.dat.  However, the current drivers request the *binaries* as
cis/*.cis.  It's too late to fix that, so put the sources in a
subdirectory here.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE                |   25 +++++++++++++++++++++----
 cis/src/3CCFEM556.cis |   22 ++++++++++++++++++++++
 cis/src/3CXEM556.cis  |   22 ++++++++++++++++++++++
 cis/src/COMpad2.cis   |   20 ++++++++++++++++++++
 cis/src/COMpad4.cis   |   14 ++++++++++++++
 cis/src/DP83903.cis   |   24 ++++++++++++++++++++++++
 cis/src/LA-PCM.cis    |   44 ++++++++++++++++++++++++++++++++++++++++++++
 cis/src/MT5634ZLX.cis |   18 ++++++++++++++++++
 cis/src/NE2K.cis      |   10 ++++++++++
 cis/src/PCMLM28.cis   |   37 +++++++++++++++++++++++++++++++++++++
 cis/src/PE-200.cis    |   11 +++++++++++
 cis/src/PE520.cis     |   11 +++++++++++
 cis/src/RS-COM-2P.cis |   14 ++++++++++++++
 cis/src/tamarack.cis  |   17 +++++++++++++++++
 14 files changed, 285 insertions(+), 4 deletions(-)
 create mode 100644 cis/src/3CCFEM556.cis
 create mode 100644 cis/src/3CXEM556.cis
 create mode 100644 cis/src/COMpad2.cis
 create mode 100644 cis/src/COMpad4.cis
 create mode 100644 cis/src/DP83903.cis
 create mode 100644 cis/src/LA-PCM.cis
 create mode 100644 cis/src/MT5634ZLX.cis
 create mode 100644 cis/src/NE2K.cis
 create mode 100644 cis/src/PCMLM28.cis
 create mode 100644 cis/src/PE-200.cis
 create mode 100644 cis/src/PE520.cis
 create mode 100644 cis/src/RS-COM-2P.cis
 create mode 100644 cis/src/tamarack.cis

diff --git a/WHENCE b/WHENCE
index a1cd744..d1e5fba 100644
--- a/WHENCE
+++ b/WHENCE
@@ -837,30 +837,42 @@ File: cis/NE2K.cis
 File: cis/tamarack.cis
 File: cis/PE-200.cis
 File: cis/PE520.cis
+Source: cis/src/LA-PCM.cis
+Source: cis/src/PCMLM28.cis
+Source: cis/src/DP83903.cis
+Source: cis/src/NE2K.cis
+Source: cis/src/tamarack.cis
+Source: cis/src/PE-200.cis
+Source: cis/src/PE520.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
 Driver: 3c589_cs - 3Com PCMCIA adapter
 
 File: cis/3CXEM556.cis
+Source: cis/src/3CXEM556.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
 Driver: 3c574_cs - 3Com PCMCIA adapter
 
 File: cis/3CCFEM556.cis
+Source: cis/src/3CCFEM556.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
@@ -870,10 +882,15 @@ File: cis/MT5634ZLX.cis
 File: cis/RS-COM-2P.cis
 File: cis/COMpad2.cis
 File: cis/COMpad4.cis
+Source: cis/src/MT5634ZLX.cis
+Source: cis/src/RS-COM-2P.cis
+Source: cis/src/COMpad2.cis
+Source: cis/src/COMpad4.cis
 
-Licence: GPL
+Licence: Dual GPLv2/MPL
 
 Originally developed by the pcmcia-cs project
+Copyright (C) 1998, 1999, 2000 David A. Hinds
 
 --------------------------------------------------------------------------
 
diff --git a/cis/src/3CCFEM556.cis b/cis/src/3CCFEM556.cis
new file mode 100644
index 0000000..be627d0
--- /dev/null
+++ b/cis/src/3CCFEM556.cis
@@ -0,0 +1,22 @@
+#
+# This card is MFC-compliant, but identifies itself as single function
+#
+vers_1 5.0, "3Com", "Megahertz 3CCFEM556", "LAN + 56k Modem"
+manfid 0x0101, 0x0556
+funcid 0
+
+mfc {
+  funcid network_adapter
+  config base 0x1000 mask 0x267 last_index 0x07
+  cftable_entry 0x07
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x000f [8bit] [16bit]
+}, {
+  funcid serial_port
+  config base 0x1100 mask 0x277 last_index 0x27
+  cftable_entry 0x27
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x0007 [8bit]
+}
diff --git a/cis/src/3CXEM556.cis b/cis/src/3CXEM556.cis
new file mode 100644
index 0000000..819f08f
--- /dev/null
+++ b/cis/src/3CXEM556.cis
@@ -0,0 +1,22 @@
+#
+# This card is MFC-compliant, but identifies itself as single function
+#
+vers_1 5.0, "3Com", "Megahertz 3CXEM556", "LAN + 56k Modem"
+manfid 0x0101, 0x0035
+funcid 0
+
+mfc {
+  funcid network_adapter
+  config base 0x0800 mask 0x63 last_index 0x07
+  cftable_entry 0x07
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x000f [8bit] [16bit]
+}, {
+  funcid serial_port
+  config base 0x900 mask 0x63 last_index 0x27
+  cftable_entry 0x27
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x0007 [8bit]
+}
diff --git a/cis/src/COMpad2.cis b/cis/src/COMpad2.cis
new file mode 100644
index 0000000..bfc2374
--- /dev/null
+++ b/cis/src/COMpad2.cis
@@ -0,0 +1,20 @@
+#
+# Replacement CIS for Advantech COMpad-32/85
+#
+dev_info
+  NULL 0ns, 512b
+vers_1 4.1, "ADVANTECH", "COMpad-32/85", "1.0"
+funcid serial_port [post]
+config base 0x0100 mask 0x0003 last_index 0x05
+cftable_entry 0x01 [default]
+  [mwait]
+  io 0x02e8-0x02ef, 0x03e8-0x03ef [lines=10] [8bit] [range]
+  irq mask 0x9eb8 [level]
+cftable_entry 0x02
+  io 0x0330-0x033f [lines=10] [8bit] [range]
+cftable_entry 0x03
+  io 0x0340-0x034f [lines=10] [8bit] [range]
+cftable_entry 0x04
+  io 0x0350-0x035f [lines=10] [8bit] [range]
+cftable_entry 0x05
+  io 0x0360-0x036f [lines=10] [8bit] [range]
diff --git a/cis/src/COMpad4.cis b/cis/src/COMpad4.cis
new file mode 100644
index 0000000..325991c
--- /dev/null
+++ b/cis/src/COMpad4.cis
@@ -0,0 +1,14 @@
+#
+# Replacement CIS for Advantech COMpad-32/85B-4
+#
+dev_info
+  NULL 0ns, 512b
+vers_1 4.1, "ADVANTECH", "COMpad-32/85B-4"
+funcid serial_port [post]
+config base 0x0100 mask 0x0001 last_index 0x02
+cftable_entry 0x01 [default]
+  [mwait]
+  io 0x0240-0x025f [lines=10] [8bit] [range]
+  irq mask 0x9eb8 [level]
+cftable_entry 0x02
+  io 0x0340-0x035f [lines=10] [8bit] [range]
diff --git a/cis/src/DP83903.cis b/cis/src/DP83903.cis
new file mode 100644
index 0000000..ce86f45
--- /dev/null
+++ b/cis/src/DP83903.cis
@@ -0,0 +1,24 @@
+#
+# This CIS is for cards based on the National Semiconductor
+# DP83903 Multiple Function Interface Chip
+#
+vers_1 4.1, "Multifunction Card", "", "", "NSC MF LAN/Modem"
+manfid 0x0175, 0x0000
+funcid 0
+
+mfc {
+  funcid network_adapter
+  config base 0x1020 mask 0x277 last_index 0x17
+  cftable_entry 0x17
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x001f [8bit] [16bit]
+    memory 0x0000-0x3fff @ 0x0000
+}, {
+  funcid serial_port
+  config base 0x1040 mask 0x0277 last_index 0x07
+  cftable_entry 0x07
+    Vcc Vnom 5V
+    irq mask 0xffff [level]
+    io  0x0000-0x0007 [8bit]
+}
diff --git a/cis/src/LA-PCM.cis b/cis/src/LA-PCM.cis
new file mode 100644
index 0000000..5c427bd
--- /dev/null
+++ b/cis/src/LA-PCM.cis
@@ -0,0 +1,44 @@
+#
+# Replacement CIS for Allied Telesis LA-PCM
+#
+dev_info
+  fn_specific 100ns, 64kb
+  FLASH 150ns, 60kb
+attr_dev_info
+  FLASH 150ns, 4kb
+manfid 0xc00f, 0x0002
+funcid network_adapter [post] [rom]
+vers_1 4.1, "Allied Telesis,K.K", "Ethernet LAN Card", "CentreCOM", "LA-PCM"
+config base 0x20000 mask 0x000b last_index 0x10
+cftable_entry 0x01
+  io 0x0200-0x021f [8bit] [16bit]
+cftable_entry 0x02
+  io 0x0220-0x023f [8bit] [16bit]
+cftable_entry 0x03
+  io 0x0240-0x025f [8bit] [16bit]
+cftable_entry 0x04
+  io 0x0260-0x027f [8bit] [16bit]
+cftable_entry 0x05
+  io 0x0280-0x029f [8bit] [16bit]
+cftable_entry 0x06
+  io 0x02a0-0x02bf [8bit] [16bit]
+cftable_entry 0x07
+  io 0x02c0-0x02df [8bit] [16bit]
+cftable_entry 0x08
+  io 0x02e0-0x02ff [8bit] [16bit]
+cftable_entry 0x09
+  io 0x0300-0x031f [8bit] [16bit]
+cftable_entry 0x0a
+  io 0x0320-0x033f [8bit] [16bit]
+cftable_entry 0x0b
+  io 0x0340-0x035f [8bit] [16bit]
+cftable_entry 0x0c
+  io 0x0360-0x037f [8bit] [16bit]
+cftable_entry 0x0d
+  io 0x0380-0x039f [8bit] [16bit]
+cftable_entry 0x0e
+  io 0x03a0-0x03bf [8bit] [16bit]
+cftable_entry 0x0f
+  io 0x03c0-0x03df [8bit] [16bit]
+cftable_entry 0x10
+  io 0x03e0-0x03ff [8bit] [16bit]
diff --git a/cis/src/MT5634ZLX.cis b/cis/src/MT5634ZLX.cis
new file mode 100644
index 0000000..52249b3
--- /dev/null
+++ b/cis/src/MT5634ZLX.cis
@@ -0,0 +1,18 @@
+#
+# Replacement CIS for Multitech MT5634ZLX modems
+#
+dev_info no_info
+vers_1 4.1, "MultiTech", "PCMCIA 56K DataFax"
+manfid 0x0200, 0x0001
+funcid serial_port
+config base 0xff80 mask 0x0067 last_index 0x27
+cftable_entry 0x0f [default]
+  [rdybsy] [audio] [pwrdown]
+  Vcc Vnom 5V Vpp1 Vnom 5V Vpp2 Vnom 5V
+  io 0x03f8-0x03ff [lines=10] [8bit]
+cftable_entry 0x17
+  io 0x02f8-0x02ff [lines=10] [8bit]
+cftable_entry 0x1f
+  io 0x03e8-0x03ef [lines=10] [8bit]
+cftable_entry 0x27
+  io 0x02e8-0x02ef [lines=10] [8bit]
diff --git a/cis/src/NE2K.cis b/cis/src/NE2K.cis
new file mode 100644
index 0000000..d1d47f3
--- /dev/null
+++ b/cis/src/NE2K.cis
@@ -0,0 +1,10 @@
+#
+# Replacement CIS for various busted NE2000-compatible cards
+#
+vers_1 4.1, "PCMCIA", "Ethernet"
+funcid network_adapter
+config base 0x03f8 mask 0x03 last_index 0x20
+cftable_entry 0x20 [default]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0000-0x001f [8bit] [16bit]
diff --git a/cis/src/PCMLM28.cis b/cis/src/PCMLM28.cis
new file mode 100644
index 0000000..39c6d16
--- /dev/null
+++ b/cis/src/PCMLM28.cis
@@ -0,0 +1,37 @@
+#
+# The on-card CIS says it is MFC-compliant, but it is not
+#
+vers_1 4.1, "LINKSYS", "PCMLM28"
+manfid 0x0143, 0xc0ab
+funcid 0
+config base 0x03f8 mask 0x03 last_index 0x2f
+
+cftable_entry 0x24 [default]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0300-0x031f, 0x02f8-0x02ff [8bit] [16bit]
+
+cftable_entry 0x25
+  io 0x0320-0x033f, 0x02f8-0x02ff [8bit] [16bit]
+cftable_entry 0x26
+  io 0x0340-0x035f, 0x02f8-0x02ff [8bit] [16bit]
+cftable_entry 0x27
+  io 0x0360-0x037f, 0x02f8-0x02ff [8bit] [16bit]
+
+cftable_entry 0x28
+  io 0x0300-0x031f, 0x03e8-0x03ef [8bit] [16bit]
+cftable_entry 0x29
+  io 0x0320-0x033f, 0x03e8-0x03ef [8bit] [16bit]
+cftable_entry 0x2a
+  io 0x0340-0x035f, 0x03e8-0x03ef [8bit] [16bit]
+cftable_entry 0x2b
+  io 0x0360-0x037f, 0x03e8-0x03ef [8bit] [16bit]
+
+cftable_entry 0x2c
+  io 0x0300-0x031f, 0x02e8-0x02ef [8bit] [16bit]
+cftable_entry 0x2d
+  io 0x0320-0x033f, 0x02e8-0x02ef [8bit] [16bit]
+cftable_entry 0x2e
+  io 0x0340-0x035f, 0x02e8-0x02ef [8bit] [16bit]
+cftable_entry 0x2f
+  io 0x0360-0x037f, 0x02e8-0x02ef [8bit] [16bit]
diff --git a/cis/src/PE-200.cis b/cis/src/PE-200.cis
new file mode 100644
index 0000000..7db7494
--- /dev/null
+++ b/cis/src/PE-200.cis
@@ -0,0 +1,11 @@
+#
+# Replacement CIS for PE-200 ethernet card
+#
+vers_1 4.1, "PMX   ", "PE-200", "ETHERNET", "R01"
+funcid network_adapter [post] [rom]
+config base 0x0100 mask 0x0001 last_index 0x01
+cftable_entry 0x1 [default]
+  [mwait]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0000-0x000f, 0x0010-0x001f [8bit] [16bit]
diff --git a/cis/src/PE520.cis b/cis/src/PE520.cis
new file mode 100644
index 0000000..fb411ab
--- /dev/null
+++ b/cis/src/PE520.cis
@@ -0,0 +1,11 @@
+#
+# Replacement CIS for LanPro EP-4000A ethernet card
+#
+vers_1 4.1, "KTI", "PE520 PLUS", "PCMCIA Ethernet"
+manfid 0x0161, 0x0010
+funcid network_adapter
+config base 0x0fd0 mask 0x0b last_index 0x01
+cftable_entry 0x01 [default]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0000-0x001f [8bit] [16bit]
diff --git a/cis/src/RS-COM-2P.cis b/cis/src/RS-COM-2P.cis
new file mode 100644
index 0000000..2e385cb
--- /dev/null
+++ b/cis/src/RS-COM-2P.cis
@@ -0,0 +1,14 @@
+#
+# Replacement CIS for dual-serial-port IO card
+#
+vers_1 4.1, "PCMCIA", "RS-COM 2P"
+funcid serial_port [post]
+config base 0x0100 mask 0x0001 last_index 0x03
+cftable_entry 0x01 [default]
+  [mwait]
+  io 0x03e8-0x03ef, 0x02e8-0x02ef [lines=10] [8bit] [range]
+  irq mask 0x9eb8 [level]
+cftable_entry 0x02
+  io 0x0250-0x0257, 0x0258-0x025f [lines=10] [8bit] [range]
+cftable_entry 0x03
+  io 0x0260-0x0267, 0x0268-0x026f [lines=10] [8bit] [range]
diff --git a/cis/src/tamarack.cis b/cis/src/tamarack.cis
new file mode 100644
index 0000000..8802694
--- /dev/null
+++ b/cis/src/tamarack.cis
@@ -0,0 +1,17 @@
+#
+# Replacement CIS for Surecom, Tamarack NE2000 cards
+#
+dev_info
+  fn_specific 100ns, 512b
+attr_dev_info
+  EEPROM 250ns, 512b
+vers_1 4.1, "TAMARACK", "Ethernet", "A", "004743118001"
+funcid network_adapter
+config base 0x03f8 mask 0x0003 last_index 0x20
+cftable_entry 0x20 [default]
+  [mwait]
+  Vcc Vnom 5V Vmin 4500mV Vmax 5500mV Istatic 100mA
+    Iavg 170mA Ipeak 200mA
+  timing wait 15us
+  io 0x0000-0x000f, 0x0010-0x001f [lines=5] [8bit] [16bit]
+  irq mask 0xffff [level]
-- 
1.7.5.1



