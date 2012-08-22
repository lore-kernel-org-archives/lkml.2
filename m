Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab2HVT1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:27:53 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:47013 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab2HVT1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:27:49 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        broonie@opensource.wolfsonmicro.com, trivial@kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH RESEND] extcon: fix typos in sys-class-extcon
Date: Wed, 22 Aug 2012 21:27:40 +0200
Message-Id: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 Documentation/ABI/testing/sysfs-class-extcon |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation/ABI/testing/sysfs-class-extcon
index 20ab361..57a7262 100644
--- a/Documentation/ABI/testing/sysfs-class-extcon
+++ b/Documentation/ABI/testing/sysfs-class-extcon
@@ -13,7 +13,7 @@ Description:
 		accessory cables have such capability. For example,
 		the 30-pin port of Nuri board (/arch/arm/mach-exynos)
 		may have both HDMI and Charger attached, or analog audio,
-		video, and USB cables attached simulteneously.
+		video, and USB cables attached simultaneously.
 
 		If there are cables mutually exclusive with each other,
 		such binary relations may be expressed with extcon_dev's
@@ -35,7 +35,7 @@ Description:
 		The /sys/class/extcon/.../state shows and stores the cable
 		attach/detach information of the corresponding extcon object.
 		If the extcon object has an optional callback "show_state"
-		defined, the showing function is overriden with the optional
+		defined, the showing function is overridden with the optional
 		callback.
 
 		If the default callback for showing function is used, the
@@ -46,19 +46,19 @@ Description:
 		TA=1
 		EAR_JACK=0
 		#
-		In this example, the extcon device have USB_OTG and TA
+		In this example, the extcon device has USB_OTG and TA
 		cables attached and HDMI and EAR_JACK cables detached.
 
 		In order to update the state of an extcon device, enter a hex
-		state number starting with 0x.
-		 echo 0xHEX > state
+		state number starting with 0x:
+		# echo 0xHEX > state
 
-		This updates the whole state of the extcon dev.
+		This updates the whole state of the extcon device.
 		Inputs of all the methods are required to meet the
-		mutually_exclusive contidions if they exist.
+		mutually_exclusive conditions if they exist.
 
 		It is recommended to use this "global" state interface if
-		you need to enter the value atomically. The later state
+		you need to set the value atomically. The later state
 		interface associated with each cable cannot update
 		multiple cable states of an extcon device simultaneously.
 
@@ -73,7 +73,7 @@ What:		/sys/class/extcon/.../cable.x/state
 Date:		February 2012
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
 Description:
-		The /sys/class/extcon/.../cable.x/name shows and stores the
+		The /sys/class/extcon/.../cable.x/state shows and stores the
 		state of cable "x" (integer between 0 and 31) of an extcon
 		device. The state value is either 0 (detached) or 1
 		(attached).
@@ -83,8 +83,8 @@ Date:		December 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
 Description:
 		Shows the relations of mutually exclusiveness. For example,
-		if the mutually_exclusive array of extcon_dev is
-		{0x3, 0x5, 0xC, 0x0}, the, the output is:
+		if the mutually_exclusive array of extcon device is
+		{0x3, 0x5, 0xC, 0x0}, then the output is:
 		# ls mutually_exclusive/
 		0x3
 		0x5
-- 
1.7.9.5

