Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422697Ab2K3Svd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:51:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:57707 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161084Ab2K3Stv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Emil Tantilov <emil.s.tantilov@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Abdallah Chatila <Abdallah.Chatila@ericsson.com>
Subject: [ 30/37] ixgbe: add support for new 82599 device id
Date: Fri, 30 Nov 2012 10:46:17 -0800
Message-Id: <20121130183900.481216781@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

commit 9e791e4a04c08868f02cd579a428a7268492e1b4 upstream.

Support for new 82599 based quad port adapter.

Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Abdallah Chatila <Abdallah.Chatila@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ixgbe/ixgbe_82599.c |    1 +
 drivers/net/ixgbe/ixgbe_main.c  |    2 ++
 drivers/net/ixgbe/ixgbe_type.h  |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/net/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ixgbe/ixgbe_82599.c
@@ -361,6 +361,7 @@ static enum ixgbe_media_type ixgbe_get_m
 	case IXGBE_DEV_ID_82599_SFP_EM:
 	case IXGBE_DEV_ID_82599_SFP_SF2:
 	case IXGBE_DEV_ID_82599EN_SFP:
+	case IXGBE_DEV_ID_82599_SFP_SF_QP:
 		media_type = ixgbe_media_type_fiber;
 		break;
 	case IXGBE_DEV_ID_82599_CX4:
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -131,6 +131,8 @@ static DEFINE_PCI_DEVICE_TABLE(ixgbe_pci
 	 board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599EN_SFP),
 	 board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF_QP),
+	 board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_X540T1),
 	 board_X540 },
 
--- a/drivers/net/ixgbe/ixgbe_type.h
+++ b/drivers/net/ixgbe/ixgbe_type.h
@@ -64,6 +64,7 @@
 #define IXGBE_DEV_ID_82599_COMBO_BACKPLANE 0x10F8
 #define IXGBE_SUBDEV_ID_82599_KX4_KR_MEZZ  0x000C
 #define IXGBE_DEV_ID_82599_LS            0x154F
+#define IXGBE_DEV_ID_82599_SFP_SF_QP     0x154A
 #define IXGBE_DEV_ID_X540T               0x1528
 #define IXGBE_DEV_ID_X540T1              0x1560
 


