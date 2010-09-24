Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab0IXQuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:50:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37454 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab0IXQuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BGa0xmnX4L7M/6cDn7be8NoODi8ZirNUdJVxXFOmERyP4+cUgcKdv7D/6XlIQ87HMu
         YZoEwjGBpUYfQZgiJ3ovApdlYFdO8K2ggyNHsCVd4uP6nsWYrtKcaeXpu8Xxzsub1drp
         0DljIej+rnh7lVuMNnxmhA6/AcfJeZQYbPgv0=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pcmcia@lists.infradead.org
Subject: [PATCH 3/5] Add files with text descriptions for CIS files
Date: Fri, 24 Sep 2010 20:49:23 +0400
Message-Id: <1285346965-23499-4-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
References: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now as we support generation of cis files from .ct, import new .ct
from original pcmcia-cs project. They correspond to the binary cis files.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 cis/3CCFEM556.ct  |   22 ++++++++++++++++++++++
 cis/3CXEM556.ct   |   22 ++++++++++++++++++++++
 cis/COMpad2.ct    |   20 ++++++++++++++++++++
 cis/COMpad4.ct    |   14 ++++++++++++++
 cis/DP83903.ct    |   24 ++++++++++++++++++++++++
 cis/E-CARD.ct     |    9 +++++++++
 cis/LA-PCM.ct     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 cis/MT5634ZLX.ct  |   18 ++++++++++++++++++
 cis/NE2K.ct       |   10 ++++++++++
 cis/PCMLM28.ct    |   37 +++++++++++++++++++++++++++++++++++++
 cis/PE-200.ct     |   11 +++++++++++
 cis/PE520.ct      |   11 +++++++++++
 cis/RS-COM-2P.ct  |   14 ++++++++++++++
 cis/SW_555_SER.ct |   19 +++++++++++++++++++
 cis/SW_7xx_SER.ct |   21 +++++++++++++++++++++
 cis/SW_8xx_SER.ct |   20 ++++++++++++++++++++
 cis/tamarack.ct   |   17 +++++++++++++++++
 17 files changed, 333 insertions(+), 0 deletions(-)
 create mode 100644 cis/3CCFEM556.ct
 create mode 100644 cis/3CXEM556.ct
 create mode 100644 cis/COMpad2.ct
 create mode 100644 cis/COMpad4.ct
 create mode 100644 cis/DP83903.ct
 create mode 100644 cis/E-CARD.ct
 create mode 100644 cis/LA-PCM.ct
 create mode 100644 cis/MT5634ZLX.ct
 create mode 100644 cis/NE2K.ct
 create mode 100644 cis/PCMLM28.ct
 create mode 100644 cis/PE-200.ct
 create mode 100644 cis/PE520.ct
 create mode 100644 cis/RS-COM-2P.ct
 create mode 100644 cis/SW_555_SER.ct
 create mode 100644 cis/SW_7xx_SER.ct
 create mode 100644 cis/SW_8xx_SER.ct
 create mode 100644 cis/tamarack.ct

diff --git a/cis/3CCFEM556.ct b/cis/3CCFEM556.ct
new file mode 100644
index 0000000..be627d0
--- /dev/null
+++ b/cis/3CCFEM556.ct
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
diff --git a/cis/3CXEM556.ct b/cis/3CXEM556.ct
new file mode 100644
index 0000000..819f08f
--- /dev/null
+++ b/cis/3CXEM556.ct
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
diff --git a/cis/COMpad2.ct b/cis/COMpad2.ct
new file mode 100644
index 0000000..bfc2374
--- /dev/null
+++ b/cis/COMpad2.ct
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
diff --git a/cis/COMpad4.ct b/cis/COMpad4.ct
new file mode 100644
index 0000000..325991c
--- /dev/null
+++ b/cis/COMpad4.ct
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
diff --git a/cis/DP83903.ct b/cis/DP83903.ct
new file mode 100644
index 0000000..ce86f45
--- /dev/null
+++ b/cis/DP83903.ct
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
diff --git a/cis/E-CARD.ct b/cis/E-CARD.ct
new file mode 100644
index 0000000..fb09b71
--- /dev/null
+++ b/cis/E-CARD.ct
@@ -0,0 +1,9 @@
+#
+# Replacement CIS for old, broken Linksys cards
+#
+vers_1 4.1, "LINKSYS", "E-CARD"
+config base 0x0008 mask 0x000b last_index 0x00
+cftable_entry 0x1 [default]
+  Vcc Vnom 5V
+  irq mask 0xffff [level]
+  io 0x0000-0x000f, 0x0010-0x001f [8bit] [16bit]
diff --git a/cis/LA-PCM.ct b/cis/LA-PCM.ct
new file mode 100644
index 0000000..5c427bd
--- /dev/null
+++ b/cis/LA-PCM.ct
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
diff --git a/cis/MT5634ZLX.ct b/cis/MT5634ZLX.ct
new file mode 100644
index 0000000..52249b3
--- /dev/null
+++ b/cis/MT5634ZLX.ct
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
diff --git a/cis/NE2K.ct b/cis/NE2K.ct
new file mode 100644
index 0000000..d1d47f3
--- /dev/null
+++ b/cis/NE2K.ct
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
diff --git a/cis/PCMLM28.ct b/cis/PCMLM28.ct
new file mode 100644
index 0000000..39c6d16
--- /dev/null
+++ b/cis/PCMLM28.ct
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
diff --git a/cis/PE-200.ct b/cis/PE-200.ct
new file mode 100644
index 0000000..7db7494
--- /dev/null
+++ b/cis/PE-200.ct
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
diff --git a/cis/PE520.ct b/cis/PE520.ct
new file mode 100644
index 0000000..fb411ab
--- /dev/null
+++ b/cis/PE520.ct
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
diff --git a/cis/RS-COM-2P.ct b/cis/RS-COM-2P.ct
new file mode 100644
index 0000000..2e385cb
--- /dev/null
+++ b/cis/RS-COM-2P.ct
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
diff --git a/cis/SW_555_SER.ct b/cis/SW_555_SER.ct
new file mode 100644
index 0000000..7519505
--- /dev/null
+++ b/cis/SW_555_SER.ct
@@ -0,0 +1,19 @@
+dev_info
+  no_info
+attr_dev_info
+  EEPROM 250ns, 512b
+manfid 0x013f, 0x0710
+funcid serial_port
+vers_1 7.0, "Sierra Wireless", "AirCard 555", "A555", "Rev 1"
+config base 0x0700 mask 0x0073 last_index 0x03
+cftable_entry 0x20 [default]
+  io 0x03f8-0x03ff [lines=3] [8bit] [range]
+  irq mask 0x3fbc [level]
+cftable_entry 0x21
+  io 0x02f8-0x02ff [lines=3] [8bit] [range]
+cftable_entry 0x22
+  io 0x03e8-0x03ef [lines=3] [8bit] [range]
+cftable_entry 0x23
+  io 0x02e8-0x02ef [lines=3] [8bit] [range]
+cftable_entry 0x24
+  io 0x0000-0x0007 [lines=3] [8bit]
diff --git a/cis/SW_7xx_SER.ct b/cis/SW_7xx_SER.ct
new file mode 100644
index 0000000..2991617
--- /dev/null
+++ b/cis/SW_7xx_SER.ct
@@ -0,0 +1,21 @@
+dev_info
+  no_info
+attr_dev_info
+  EEPROM 250ns, 512b
+manfid 0x0192, 0x0710
+funcid serial_port
+vers_1 7.0, "Sierra Wireless", "AC710/AC750", "GPRS Network Adapter",
+  "R1"
+config base 0x0700 mask 0x0073 last_index 0x03
+cftable_entry 0x20 [default]
+  Vcc Istatic 45mA Iavg 50mA Ipeak 55mA Idown 20mA
+  io 0x03f8-0x03ff [lines=3] [8bit] [range]
+  irq mask 0x86bc [level]
+cftable_entry 0x21
+  io 0x02f8-0x02ff [lines=3] [8bit] [range]
+cftable_entry 0x22
+  io 0x03e8-0x03ef [lines=3] [8bit] [range]
+cftable_entry 0x23
+  io 0x02e8-0x02ef [lines=3] [8bit] [range]
+cftable_entry 0x24
+  io 0x0000-0x0007 [lines=3] [8bit]
diff --git a/cis/SW_8xx_SER.ct b/cis/SW_8xx_SER.ct
new file mode 100644
index 0000000..7dbdd57
--- /dev/null
+++ b/cis/SW_8xx_SER.ct
@@ -0,0 +1,20 @@
+dev_info
+  no_info
+attr_dev_info
+  EEPROM 250ns, 512b
+manfid 0x0192, 0x0710
+funcid serial_port
+vers_1 7.0, "Sierra Wireless", "AC850", "3G Network Adapter", "R1"
+config base 0x0700 mask 0x0073 last_index 0x03
+cftable_entry 0x20 [default]
+  Vcc Istatic 45mA Iavg 50mA Ipeak 55mA Idown 20mA
+  io 0x48f8-0x48ff [lines=3] [8bit] [range]
+  irq mask 0x86bc [level]
+cftable_entry 0x21
+  io 0x47f8-0x47ff [lines=3] [8bit] [range]
+cftable_entry 0x22
+  io 0x48e8-0x48ef [lines=3] [8bit] [range]
+cftable_entry 0x23
+  io 0x47e8-0x47ef [lines=3] [8bit] [range]
+cftable_entry 0x24
+  io 0x0000-0x0007 [lines=3] [8bit]
diff --git a/cis/tamarack.ct b/cis/tamarack.ct
new file mode 100644
index 0000000..8802694
--- /dev/null
+++ b/cis/tamarack.ct
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
1.7.1

