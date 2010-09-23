Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0IWPUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:20:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36448 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab0IWPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AYLqG1o2rjh0pwxCLYkkRBbny1Lt9flmXTcXGrkbagc/RirMCPyo3XMci6lubSW7+s
         f3kmeJuzU+ia0a42FY27Jfrz1qnlwIKGjOom5Bfl8cVU85GZqakm6qsnBoURiEUl1Qgg
         SR8vQE52axCCPL31dQPYWbDUGNPXeLsfi0hcI=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 4/5] firmware: replace ihex files with text descriptions for CIS files
Date: Thu, 23 Sep 2010 19:19:56 +0400
Message-Id: <1285255197-9262-4-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
References: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now as we support generation of cis files from .ct, drop old ihex files
and import new .ct from original pcmcia-cs project.
This brings no actual changes in the binary firmware files.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 firmware/cis/3CCFEM556.cis.ihex  |   13 -----------
 firmware/cis/3CCFEM556.ct        |   22 +++++++++++++++++++
 firmware/cis/3CXEM556.cis.ihex   |   13 -----------
 firmware/cis/3CXEM556.ct         |   22 +++++++++++++++++++
 firmware/cis/COMpad2.cis.ihex    |   11 ---------
 firmware/cis/COMpad2.ct          |   20 +++++++++++++++++
 firmware/cis/COMpad4.cis.ihex    |    9 -------
 firmware/cis/COMpad4.ct          |   14 ++++++++++++
 firmware/cis/DP83903.cis.ihex    |   14 ------------
 firmware/cis/DP83903.ct          |   24 ++++++++++++++++++++
 firmware/cis/E-CARD.ct           |    9 +++++++
 firmware/cis/LA-PCM.cis.ihex     |   20 -----------------
 firmware/cis/LA-PCM.ct           |   44 ++++++++++++++++++++++++++++++++++++++
 firmware/cis/MT5634ZLX.cis.ihex  |   11 ---------
 firmware/cis/MT5634ZLX.ct        |   18 +++++++++++++++
 firmware/cis/NE2K.cis.ihex       |    8 -------
 firmware/cis/NE2K.ct             |   10 ++++++++
 firmware/cis/PCMLM28.cis.ihex    |   18 ---------------
 firmware/cis/PCMLM28.ct          |   37 +++++++++++++++++++++++++++++++
 firmware/cis/PE-200.cis.ihex     |    9 -------
 firmware/cis/PE-200.ct           |   11 +++++++++
 firmware/cis/PE520.cis.ihex      |    9 -------
 firmware/cis/PE520.ct            |   11 +++++++++
 firmware/cis/RS-COM-2P.cis.ihex  |   10 --------
 firmware/cis/RS-COM-2P.ct        |   14 ++++++++++++
 firmware/cis/SW_555_SER.cis.ihex |   12 ----------
 firmware/cis/SW_555_SER.ct       |   19 ++++++++++++++++
 firmware/cis/SW_7xx_SER.cis.ihex |   13 -----------
 firmware/cis/SW_7xx_SER.ct       |   21 ++++++++++++++++++
 firmware/cis/SW_8xx_SER.cis.ihex |   13 -----------
 firmware/cis/SW_8xx_SER.ct       |   20 +++++++++++++++++
 firmware/cis/tamarack.cis.ihex   |   10 --------
 firmware/cis/tamarack.ct         |   17 ++++++++++++++
 33 files changed, 333 insertions(+), 193 deletions(-)
 delete mode 100644 firmware/cis/3CCFEM556.cis.ihex
 create mode 100644 firmware/cis/3CCFEM556.ct
 delete mode 100644 firmware/cis/3CXEM556.cis.ihex
 create mode 100644 firmware/cis/3CXEM556.ct
 delete mode 100644 firmware/cis/COMpad2.cis.ihex
 create mode 100644 firmware/cis/COMpad2.ct
 delete mode 100644 firmware/cis/COMpad4.cis.ihex
 create mode 100644 firmware/cis/COMpad4.ct
 delete mode 100644 firmware/cis/DP83903.cis.ihex
 create mode 100644 firmware/cis/DP83903.ct
 create mode 100644 firmware/cis/E-CARD.ct
 delete mode 100644 firmware/cis/LA-PCM.cis.ihex
 create mode 100644 firmware/cis/LA-PCM.ct
 delete mode 100644 firmware/cis/MT5634ZLX.cis.ihex
 create mode 100644 firmware/cis/MT5634ZLX.ct
 delete mode 100644 firmware/cis/NE2K.cis.ihex
 create mode 100644 firmware/cis/NE2K.ct
 delete mode 100644 firmware/cis/PCMLM28.cis.ihex
 create mode 100644 firmware/cis/PCMLM28.ct
 delete mode 100644 firmware/cis/PE-200.cis.ihex
 create mode 100644 firmware/cis/PE-200.ct
 delete mode 100644 firmware/cis/PE520.cis.ihex
 create mode 100644 firmware/cis/PE520.ct
 delete mode 100644 firmware/cis/RS-COM-2P.cis.ihex
 create mode 100644 firmware/cis/RS-COM-2P.ct
 delete mode 100644 firmware/cis/SW_555_SER.cis.ihex
 create mode 100644 firmware/cis/SW_555_SER.ct
 delete mode 100644 firmware/cis/SW_7xx_SER.cis.ihex
 create mode 100644 firmware/cis/SW_7xx_SER.ct
 delete mode 100644 firmware/cis/SW_8xx_SER.cis.ihex
 create mode 100644 firmware/cis/SW_8xx_SER.ct
 delete mode 100644 firmware/cis/tamarack.cis.ihex
 create mode 100644 firmware/cis/tamarack.ct

diff --git a/firmware/cis/3CCFEM556.cis.ihex b/firmware/cis/3CCFEM556.cis.ihex
deleted file mode 100644
index e4d92b1..0000000
--- a/firmware/cis/3CCFEM556.cis.ihex
+++ /dev/null
@@ -1,13 +0,0 @@
-:1000000001030000FF152D050033436F6D004D65A2
-:100010006761686572747A2033434346454D3535D0
-:1000200036004C414E202B2035366B204D6F6465D9
-:100030006D0000FF20040101560521020000060B9F
-:1000400002004D000000006B000000FF001303439E
-:100050004953210206001A060507001067021B0912
-:1000600087011901556430FFFFFF00130343495313
-:10007000210202001A060527001177021B09A701B9
-:090080001901552330FFFFFF00B8
-:00000001FF
-#
-# This card is MFC-compliant, but identifies itself as single function
-#
diff --git a/firmware/cis/3CCFEM556.ct b/firmware/cis/3CCFEM556.ct
new file mode 100644
index 0000000..be627d0
--- /dev/null
+++ b/firmware/cis/3CCFEM556.ct
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
diff --git a/firmware/cis/3CXEM556.cis.ihex b/firmware/cis/3CXEM556.cis.ihex
deleted file mode 100644
index 895010b..0000000
--- a/firmware/cis/3CXEM556.cis.ihex
+++ /dev/null
@@ -1,13 +0,0 @@
-:1000000001030000FF152C050033436F6D004D65A3
-:100010006761686572747A20334358454D353536CB
-:10002000004C414E202B2035366B204D6F64656DA2
-:100030000000FF20040101350021020000060B0230
-:10004000004C0000000069000000FF00130343495A
-:1000500053210206001A0501070008631B098701E6
-:100060001901556430FFFFFF001303434953210278
-:1000700002001A0501270009631B09A70119015590
-:060080002330FFFFFF002A
-:00000001FF
-#
-# This card is MFC-compliant, but identifies itself as single function
-#
diff --git a/firmware/cis/3CXEM556.ct b/firmware/cis/3CXEM556.ct
new file mode 100644
index 0000000..819f08f
--- /dev/null
+++ b/firmware/cis/3CXEM556.ct
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
diff --git a/firmware/cis/COMpad2.cis.ihex b/firmware/cis/COMpad2.cis.ihex
deleted file mode 100644
index 1671c5e..0000000
--- a/firmware/cis/COMpad2.cis.ihex
+++ /dev/null
@@ -1,11 +0,0 @@
-:1000000001030000FF151F0401414456414E5445B1
-:10001000434800434F4D7061642D33322F38350013
-:10002000312E300000FF210202011A0501050001F6
-:10003000031B0EC18118AA61E80207E8030730B864
-:100040009E1B08820108AA6030030F1B0883010869
-:10005000AA6040030F1B08840108AA6050030F1B0D
-:0D00600008850108AA6060030F1400FF006E
-:00000001FF
-#
-# Replacement CIS for Advantech COMpad-32/85
-#
diff --git a/firmware/cis/COMpad2.ct b/firmware/cis/COMpad2.ct
new file mode 100644
index 0000000..bfc2374
--- /dev/null
+++ b/firmware/cis/COMpad2.ct
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
diff --git a/firmware/cis/COMpad4.cis.ihex b/firmware/cis/COMpad4.cis.ihex
deleted file mode 100644
index 27bbec1..0000000
--- a/firmware/cis/COMpad4.cis.ihex
+++ /dev/null
@@ -1,9 +0,0 @@
-:1000000001030000FF151F0401414456414E5445B1
-:10001000434800434F4D7061642D33322F383542D1
-:100020002D34000000FF210202011A050102000127
-:10003000011B0BC18118AA6040021F30B89E1B082B
-:0C004000820108AA6040031F1400FF00AA
-:00000001FF
-#
-# Replacement CIS for Advantech COMpad-32/85B-4
-#
diff --git a/firmware/cis/COMpad4.ct b/firmware/cis/COMpad4.ct
new file mode 100644
index 0000000..325991c
--- /dev/null
+++ b/firmware/cis/COMpad4.ct
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
diff --git a/firmware/cis/DP83903.cis.ihex b/firmware/cis/DP83903.cis.ihex
deleted file mode 100644
index 6d73ea3..0000000
--- a/firmware/cis/DP83903.cis.ihex
+++ /dev/null
@@ -1,14 +0,0 @@
-:1000000001030000FF152904014D756C74696675C4
-:100010006E6374696F6E20436172640000004E531A
-:1000200043204D46204C414E2F4D6F64656D00FFBF
-:1000300020047501000021020000060B02004900A7
-:100040000000006A000000FF00130343495321022F
-:1000500006001A060517201077021B0C970179017C
-:10006000556530FFFF284000FF001303434953212B
-:100070000202001A060507401077021B09870119C2
-:0800800001552330FFFFFF00D2
-:00000001FF
-#
-# This CIS is for cards based on the National Semiconductor
-# DP83903 Multiple Function Interface Chip
-#
diff --git a/firmware/cis/DP83903.ct b/firmware/cis/DP83903.ct
new file mode 100644
index 0000000..ce86f45
--- /dev/null
+++ b/firmware/cis/DP83903.ct
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
diff --git a/firmware/cis/E-CARD.ct b/firmware/cis/E-CARD.ct
new file mode 100644
index 0000000..fb09b71
--- /dev/null
+++ b/firmware/cis/E-CARD.ct
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
diff --git a/firmware/cis/LA-PCM.cis.ihex b/firmware/cis/LA-PCM.cis.ihex
deleted file mode 100644
index a0ff0c7..0000000
--- a/firmware/cis/LA-PCM.cis.ihex
+++ /dev/null
@@ -1,20 +0,0 @@
-:100000000105D4F953E9FF17035338FF20040FC04B
-:1000100002002102060315390401416C6C69656414
-:100020002054656C657369732C4B2E4B00457468C6
-:1000300065726E6574204C414E20436172640043CA
-:10004000656E747265434F4D004C412D50434D0019
-:10005000FF1A0602100000020B1B08810108E06075
-:1000600000021F1B08820108E06020021F1B08839A
-:100070000108E06040021F1B08840108E060600284
-:100080001F1B08850108E06080021F1B088601080D
-:10009000E060A0021F1B08870108E060C0021F1B70
-:1000A00008880108E060E0021F1B08890108E06081
-:1000B00000031F1B088A0108E06020031F1B088B38
-:1000C0000108E06040031F1B088C0108E06060032A
-:1000D0001F1B088D0108E06080031F1B088E0108AC
-:1000E000E060A0031F1B088F0108E060C0031F1B16
-:0D00F00008900108E060E0031F1400FF000D
-:00000001FF
-#
-# Replacement CIS for Allied Telesis LA-PCM
-#
diff --git a/firmware/cis/LA-PCM.ct b/firmware/cis/LA-PCM.ct
new file mode 100644
index 0000000..5c427bd
--- /dev/null
+++ b/firmware/cis/LA-PCM.ct
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
diff --git a/firmware/cis/MT5634ZLX.cis.ihex b/firmware/cis/MT5634ZLX.cis.ihex
deleted file mode 100644
index 72500b9..0000000
--- a/firmware/cis/MT5634ZLX.cis.ihex
+++ /dev/null
@@ -1,11 +0,0 @@
-:100000000101FF152204014D756C74695465636824
-:100010000050434D4349412035364B2044617461C3
-:10002000466178000000FF20040002010021020266
-:10003000001A05012780FF671B0FCF418B01550177
-:10004000550155AA60F80307281B08970108AA6004
-:10005000F802071B089F0108AA60E803071B08A70E
-:0B0060000108AA60E802071400FF007E
-:00000001FF
-#
-# Replacement CIS for Multitech MT5634ZLX modems
-#
diff --git a/firmware/cis/MT5634ZLX.ct b/firmware/cis/MT5634ZLX.ct
new file mode 100644
index 0000000..52249b3
--- /dev/null
+++ b/firmware/cis/MT5634ZLX.ct
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
diff --git a/firmware/cis/NE2K.cis.ihex b/firmware/cis/NE2K.cis.ihex
deleted file mode 100644
index 1bb40fc..0000000
--- a/firmware/cis/NE2K.cis.ihex
+++ /dev/null
@@ -1,8 +0,0 @@
-:1000000001030000FF1515040150434D4349410011
-:1000100045746865726E6574000000FF2102060079
-:100020001A050120F803031B09E001190155653089
-:06003000FFFF1400FF00B9
-:00000001FF
-#
-# Replacement CIS for various busted NE2000-compatible cards
-#
diff --git a/firmware/cis/NE2K.ct b/firmware/cis/NE2K.ct
new file mode 100644
index 0000000..d1d47f3
--- /dev/null
+++ b/firmware/cis/NE2K.ct
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
diff --git a/firmware/cis/PCMLM28.cis.ihex b/firmware/cis/PCMLM28.cis.ihex
deleted file mode 100644
index ffdfe85..0000000
--- a/firmware/cis/PCMLM28.cis.ihex
+++ /dev/null
@@ -1,18 +0,0 @@
-:1000000001030000FF151504014C494E4B53595391
-:100010000050434D4C4D3238000000FF2004430196
-:10002000ABC0210200001A05012FF803031B10E4E6
-:1000300001190155E06100031FF8020730FFFF1BA3
-:100040000BA50108E06120031FF802071B0BA601A6
-:1000500008E06140031FF802071B0BA70108E061DD
-:1000600060031FF802071B0BA80108E06100031FD3
-:10007000E803071B0BA90108E06120031FE8030741
-:100080001B0BAA0108E06140031FE803071B0BAB31
-:100090000108E06160031FE803071B0BAC0108E0E7
-:1000A0006100031FE802071B0BAD0108E06120039C
-:1000B0001FE802071B0BAE0108E06140031FE802C6
-:1000C000071B0BAF0108E06160031FE80207140083
-:0200D000FF002F
-:00000001FF
-#
-# The on-card CIS says it is MFC-compliant, but it is not
-#
diff --git a/firmware/cis/PCMLM28.ct b/firmware/cis/PCMLM28.ct
new file mode 100644
index 0000000..39c6d16
--- /dev/null
+++ b/firmware/cis/PCMLM28.ct
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
diff --git a/firmware/cis/PE-200.cis.ihex b/firmware/cis/PE-200.cis.ihex
deleted file mode 100644
index e6dbdab..0000000
--- a/firmware/cis/PE-200.cis.ihex
+++ /dev/null
@@ -1,9 +0,0 @@
-:1000000001030000FF151E0401504D582020200060
-:1000100050452D3230300045544845524E4554002D
-:1000200052303100FF210206031A050101000101CF
-:100030001B0EC181190155E051000F100F30FFFF59
-:040040001400FF00A9
-:00000001FF
-#
-# Replacement CIS for PE-200 ethernet card
-#
diff --git a/firmware/cis/PE-200.ct b/firmware/cis/PE-200.ct
new file mode 100644
index 0000000..7db7494
--- /dev/null
+++ b/firmware/cis/PE-200.ct
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
diff --git a/firmware/cis/PE520.cis.ihex b/firmware/cis/PE520.cis.ihex
deleted file mode 100644
index 97a745b..0000000
--- a/firmware/cis/PE520.cis.ihex
+++ /dev/null
@@ -1,9 +0,0 @@
-:1000000001030000FF152304014B544900504535FE
-:10001000323020504C55530050434D434941204508
-:10002000746865726E65740000FF20046101100041
-:10003000210206001A050101D00F0B1B09C101198D
-:0A00400001556530FFFF1400FF00BA
-:00000001FF
-#
-# Replacement CIS for PE520 ethernet card
-#
diff --git a/firmware/cis/PE520.ct b/firmware/cis/PE520.ct
new file mode 100644
index 0000000..fb411ab
--- /dev/null
+++ b/firmware/cis/PE520.ct
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
diff --git a/firmware/cis/RS-COM-2P.cis.ihex b/firmware/cis/RS-COM-2P.cis.ihex
deleted file mode 100644
index 0801ca5..0000000
--- a/firmware/cis/RS-COM-2P.cis.ihex
+++ /dev/null
@@ -1,10 +0,0 @@
-:1000000001030000FF1516040150434D4349410010
-:1000100052532D434F4D203250000000FF21020269
-:10002000011A0501030001011B0EC18118AA61E834
-:100030000307E8020730B89E1B0B820108AA615033
-:1000400002075802071B0B830108AA6160020768B8
-:0600500002071400FF008E
-:00000001FF
-#
-# Replacement CIS for dual-serial-port IO card
-#
diff --git a/firmware/cis/RS-COM-2P.ct b/firmware/cis/RS-COM-2P.ct
new file mode 100644
index 0000000..2e385cb
--- /dev/null
+++ b/firmware/cis/RS-COM-2P.ct
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
diff --git a/firmware/cis/SW_555_SER.cis.ihex b/firmware/cis/SW_555_SER.cis.ihex
deleted file mode 100644
index 9b9348a..0000000
--- a/firmware/cis/SW_555_SER.cis.ihex
+++ /dev/null
@@ -1,12 +0,0 @@
-:100000000101FF17034100FF20043F0110072102F7
-:100010000200152A070053696572726120576972E0
-:10002000656C657373004169724361726420353594
-:1000300035004135353500526576203100FF1A050F
-:1000400001030007731B0BE00118A360F8030730DE
-:10005000BC3F1B08A10108A360F802071B08A2010E
-:1000600008A360E803071B08A30108A360E80207D0
-:0A0070001B04A40108231400FF0084
-:00000001FF
-#
-# Replacement CIS for AC555 provided by Sierra Wireless
-#
diff --git a/firmware/cis/SW_555_SER.ct b/firmware/cis/SW_555_SER.ct
new file mode 100644
index 0000000..7519505
--- /dev/null
+++ b/firmware/cis/SW_555_SER.ct
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
diff --git a/firmware/cis/SW_7xx_SER.cis.ihex b/firmware/cis/SW_7xx_SER.cis.ihex
deleted file mode 100644
index 11e44ad..0000000
--- a/firmware/cis/SW_7xx_SER.cis.ihex
+++ /dev/null
@@ -1,13 +0,0 @@
-:100000000101FF17034100FF2004920110072102A4
-:1000100002001537070053696572726120576972D3
-:10002000656C6573730041433731302F4143373579
-:10003000300047505253204E6574776F726B2041E9
-:1000400064617074657200523100FF1A050103008B
-:1000500007731B10E00119784D555D25A360F80367
-:100060000730BC861B08A10108A360F802071B0823
-:10007000A20108A360E803071B08A30108A360E826
-:0C00800002071B04A40108231400FF0069
-:00000001FF
-#
-# Replacement CIS for AC7xx provided by Sierra Wireless
-#
diff --git a/firmware/cis/SW_7xx_SER.ct b/firmware/cis/SW_7xx_SER.ct
new file mode 100644
index 0000000..2991617
--- /dev/null
+++ b/firmware/cis/SW_7xx_SER.ct
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
diff --git a/firmware/cis/SW_8xx_SER.cis.ihex b/firmware/cis/SW_8xx_SER.cis.ihex
deleted file mode 100644
index bbcfe63..0000000
--- a/firmware/cis/SW_8xx_SER.cis.ihex
+++ /dev/null
@@ -1,13 +0,0 @@
-:100000000101FF17034100FF2004920110072102A4
-:100010000200152F070053696572726120576972DB
-:10002000656C657373004143383530003347204EAB
-:100030006574776F726B20416461707465720052F1
-:100040003100FF1A0501030007731B10E001197846
-:100050004D555D25A360F8480730BC861B08A101FB
-:1000600008A360F847071B08A20108A360E8480737
-:100070001B08A30108A360E847071B04A401082389
-:040080001400FF0069
-:00000001FF
-#
-# Replacement CIS for AC8xx provided by Sierra Wireless
-#
diff --git a/firmware/cis/SW_8xx_SER.ct b/firmware/cis/SW_8xx_SER.ct
new file mode 100644
index 0000000..7dbdd57
--- /dev/null
+++ b/firmware/cis/SW_8xx_SER.ct
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
diff --git a/firmware/cis/tamarack.cis.ihex b/firmware/cis/tamarack.cis.ihex
deleted file mode 100644
index 1e86547..0000000
--- a/firmware/cis/tamarack.cis.ihex
+++ /dev/null
@@ -1,10 +0,0 @@
-:100000000103D400FF17034100FF152404015441EC
-:100010004D415241434B0045746865726E657400F2
-:10002000410030303437343331313830303100FF33
-:10003000210206001A050120F803031B14E08119B0
-:100040003F554D5D06864626E551000F100F30FFE7
-:05005000FF1400FF0099
-:00000001FF
-#
-# Replacement CIS for Surecom, Tamarack NE2000 cards
-#
diff --git a/firmware/cis/tamarack.ct b/firmware/cis/tamarack.ct
new file mode 100644
index 0000000..8802694
--- /dev/null
+++ b/firmware/cis/tamarack.ct
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
1.5.6.5

