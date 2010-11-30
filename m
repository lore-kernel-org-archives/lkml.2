Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab0K3NXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:23:32 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45236 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0K3NXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:23:31 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: [stable] Linux 2.6.32.26+drm33.12
Date: Tue, 30 Nov 2010 14:23:29 +0100
Message-Id: <1291123409-17337-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: linux-kernel@vger.kernel.org
To: kernel-team@lists.ubuntu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.26+drm33.12 stable tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/radeon: fix PCI ID 5657 to be an RV410
* Linux 2.6.32.26+drm33.12

 Makefile                 |    2 +-
 include/drm/drm_pciids.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 906d43e..5c0d69c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .26+drm33.11
+EXTRAVERSION = .26+drm33.12
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 0cbdccc..3d016e9 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -85,7 +85,6 @@
 	{0x1002, 0x5460, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x5462, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x5464, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_IS_MOBILITY}, \
-	{0x1002, 0x5657, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV380|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5548, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R423|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5549, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R423|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x554A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R423|RADEON_NEW_MEMMAP}, \
@@ -103,6 +102,7 @@
 	{0x1002, 0x564F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5652, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5653, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x5657, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV410|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x5834, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS300|RADEON_IS_IGP}, \
 	{0x1002, 0x5835, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS300|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x5954, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS480|RADEON_IS_IGP|RADEON_IS_MOBILITY|RADEON_IS_IGPGART}, \
