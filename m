Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0IXTWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:22:21 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:38701 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757853Ab0IXTWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:22:15 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 23/24] usb: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:33 -0700
Message-Id: <1dd0f4a1709a9b139fe87f2b311cc0d129900b3f.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <58b418c2e7311bffb13606a6b94e33ddb7569346.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
 <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
 <b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
 <2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
 <ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
 <8cea68a58c5ddba79fc96e93fa0b23681e6a7ffe.1285355033.git.mfm@muteddisk.com>
 <e93a3f1af26d2b0fc798b4c15401b3422ae6e2bd.1285355033.git.mfm@muteddisk.com>
 <c2f1ef5590660ae574e9bdaf7136213741081404.1285355033.git.mfm@muteddisk.com>
 <efe88633e146de3e173afea14f777c41c37e5db2.1285355033.git.mfm@muteddisk.com>
 <facbf79cadc81f9043e89160b7b3b8a90926aba1.1285355033.git.mfm@muteddisk.com>
 <f8ffc630c8a56ebd5da0aa2227d63fecc21d4ee7.1285355033.git.mfm@muteddisk.com>
 <0472f95473283ce75285e458b22b86ff791d7a42.1285355033.git.mfm@muteddisk.com>
 <75da5e0e0a547b4acbc7cfbdf35c29a24512ca37.1285355033.git.mfm@muteddisk.com>
 <30c1ad7f4200136e00723fd76da1e58200e6e5b0.1285355033.git.mfm@muteddisk.com>
 <06e70fe4f8a51f65f3582c353329939a8548d897.1285355033.git.mfm@muteddisk.com>
 <a2fd5831df37b0a306ab4ca51d2e86ea7ee06425.1285355033.git.mfm@muteddisk.com>
 <58b418c2e7311bffb13606a6b94e33ddb7569346.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/usb/atm/Makefile      |    4 +---
 drivers/usb/core/Makefile     |    4 +---
 drivers/usb/gadget/Makefile   |    4 +---
 drivers/usb/host/Makefile     |    4 +---
 drivers/usb/misc/Makefile     |    4 +---
 drivers/usb/musb/Makefile     |    4 +---
 drivers/usb/storage/Makefile  |    2 +-
 drivers/usb/wusbcore/Makefile |    4 +---
 8 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/atm/Makefile b/drivers/usb/atm/Makefile
index 4c4a776..d40a126 100644
--- a/drivers/usb/atm/Makefile
+++ b/drivers/usb/atm/Makefile
@@ -8,6 +8,4 @@ obj-$(CONFIG_USB_UEAGLEATM)	+= ueagle-atm.o
 obj-$(CONFIG_USB_ATM)		+= usbatm.o
 obj-$(CONFIG_USB_XUSBATM)	+= xusbatm.o
 
-ifeq ($(CONFIG_USB_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_USB_DEBUG)	:= -DDEBUG
diff --git a/drivers/usb/core/Makefile b/drivers/usb/core/Makefile
index ec16e60..17c8e2d 100644
--- a/drivers/usb/core/Makefile
+++ b/drivers/usb/core/Makefile
@@ -16,6 +16,4 @@ endif
 
 obj-$(CONFIG_USB)	+= usbcore.o
 
-ifeq ($(CONFIG_USB_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 27283df..c682005 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -1,9 +1,7 @@
 #
 # USB peripheral controller drivers
 #
-ifeq ($(CONFIG_USB_GADGET_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
+ccflags-$(CONFIG_USB_GADGET_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_USB_DUMMY_HCD)	+= dummy_hcd.o
 obj-$(CONFIG_USB_NET2280)	+= net2280.o
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index b6315aa..f041442 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -2,9 +2,7 @@
 # Makefile for USB Host Controller Drivers
 #
 
-ifeq ($(CONFIG_USB_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
+ccflags-$(CONFIG_USB_DEBUG)	:= -DDEBUG
 
 isp1760-objs := isp1760-hcd.o isp1760-if.o
 fhci-objs := fhci-hcd.o fhci-hub.o fhci-q.o fhci-mem.o \
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 717703e..92d1ce0 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -25,6 +25,4 @@ obj-$(CONFIG_USB_SEVSEG)	+= usbsevseg.o
 
 obj-$(CONFIG_USB_SISUSBVGA)	+= sisusbvga/
 
-ifeq ($(CONFIG_USB_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_USB_DEBUG)	:= -DDEBUG
diff --git a/drivers/usb/musb/Makefile b/drivers/usb/musb/Makefile
index 9705f71..4fd29f8 100644
--- a/drivers/usb/musb/Makefile
+++ b/drivers/usb/musb/Makefile
@@ -74,6 +74,4 @@ endif
 
 # Debugging
 
-ifeq ($(CONFIG_USB_MUSB_DEBUG),y)
-	EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_USB_MUSB_DEBUG) := -DDEBUG
diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
index ef7e5a8..786f086 100644
--- a/drivers/usb/storage/Makefile
+++ b/drivers/usb/storage/Makefile
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
-EXTRA_CFLAGS	:= -Idrivers/scsi
+ccflags-y	:= -Idrivers/scsi
 
 obj-$(CONFIG_USB_STORAGE)	+= usb-storage.o
 
diff --git a/drivers/usb/wusbcore/Makefile b/drivers/usb/wusbcore/Makefile
index 75f1ade..f0d8045 100644
--- a/drivers/usb/wusbcore/Makefile
+++ b/drivers/usb/wusbcore/Makefile
@@ -21,6 +21,4 @@ wusb-wa-objs :=	wa-hc.o		\
 		wa-rpipe.o	\
 		wa-xfer.o
 
-ifeq ($(CONFIG_USB_WUSB_CBAF_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_USB_WUSB_CBAF_DEBUG) := -DDEBUG
-- 
1.7.2.1

