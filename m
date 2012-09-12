Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2ILX6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:58:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab2ILXmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:42:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        James Ralston <james.d.ralston@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 76/85] i2c-i801: Add Device IDs for Intel Lynx Point-LP PCH
Date: Wed, 12 Sep 2012 16:36:59 -0700
Message-Id: <20120912233549.658499485@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 4a8f1ddde942e232387e6129ce4f4c412e43802f upstream.

Add the SMBus Device IDs for the Intel Lynx Point-LP PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/i2c/busses/i2c-i801 |    1 +
 drivers/i2c/busses/Kconfig        |    1 +
 drivers/i2c/busses/i2c-i801.c     |    3 +++
 3 files changed, 5 insertions(+)

--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -21,6 +21,7 @@ Supported adapters:
   * Intel DH89xxCC (PCH)
   * Intel Panther Point (PCH)
   * Intel Lynx Point (PCH)
+  * Intel Lynx Point-LP (PCH)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -104,6 +104,7 @@ config I2C_I801
 	    DH89xxCC (PCH)
 	    Panther Point (PCH)
 	    Lynx Point (PCH)
+	    Lynx Point-LP (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -52,6 +52,7 @@
   DH89xxCC (PCH)        0x2330     32     hard     yes     yes     yes
   Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
   Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
+  Lynx Point-LP (PCH)   0x9c22     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -147,6 +148,7 @@
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
 
 struct i801_priv {
 	struct i2c_adapter adapter;
@@ -636,6 +638,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids)
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
 	{ 0, }
 };
 


