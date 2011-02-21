Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab1BUVeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:34:15 -0500
Received: from mx2.parallels.com ([64.131.90.16]:59460 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1BUVeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:34:14 -0500
Message-ID: <4D62DA51.8020108@parallels.com>
Date: Mon, 21 Feb 2011 15:34:09 -0600
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Mariusz Kozlowski <mk@lab.zgora.pl>, LKML <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH] Remove obsolete Documentation/powerpc/00-INDEX entries
References: <4D6095E3.2040103@parallels.com>	<20110221185205.GA23284@mako-laptop>	<4D62C43F.5040302@parallels.com>	<20110221120303.48106f6c.rdunlap@xenotime.net>	<4D62CC6B.9070408@parallels.com> <20110221125555.4a47424d.rdunlap@xenotime.net>
In-Reply-To: <20110221125555.4a47424d.rdunlap@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.134.148.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rlandley@parallels.com>

The device tree infrastructure is being genericized so its documentation
moved out of the PowerPC directory.

Signed-off-by: Rob Landley <rlandley@parallels.com>
---

 Documentation/devicetree/00-INDEX |    8 ++++++++
 Documentation/powerpc/00-INDEX    |    4 ----
 2 files changed, 8 insertions(+), 4 deletions(-)

--- /dev/null	2011-02-13 16:59:19.073990002 -0600
+++ b/Documentation/devicetree/00-INDEX	2011-02-21 14:47:12.911544002 -0600
@@ -0,0 +1,8 @@
+Documentation for device trees, a data structure by which bootloaders pass
+hardware layout to Linux in a device-independent manner, simplifying hardware
+probing.  This subsystem is maintained by Grant Likely
+<grant.likely@secretlab.ca> and has a mailing list at
+https://lists.ozlabs.org/listinfo/devicetree-discuss
+
+booting-without-of.txt
+        - Booting Linux without Open Firmware, describes history and format of device trees.
diff --git a/Documentation/powerpc/00-INDEX b/Documentation/powerpc/00-INDEX
index e3960b8..5620fb5 100644
--- a/Documentation/powerpc/00-INDEX
+++ b/Documentation/powerpc/00-INDEX
@@ -5,8 +5,6 @@ please mail me.
 
 00-INDEX
 	- this file
-booting-without-of.txt
-	- Booting the Linux/ppc kernel without Open Firmware
 cpu_features.txt
 	- info on how we support a variety of CPUs with minimal compile-time
 	options.
@@ -16,8 +14,6 @@ hvcs.txt
 	- IBM "Hypervisor Virtual Console Server" Installation Guide
 mpc52xx.txt
 	- Linux 2.6.x on MPC52xx family
-mpc52xx-device-tree-bindings.txt
-	- MPC5200 Device Tree Bindings
 sound.txt
 	- info on sound support under Linux/PPC
 zImage_layout.txt
