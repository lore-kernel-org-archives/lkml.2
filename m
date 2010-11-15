Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0KOPHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:07:08 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54031 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab0KOPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:07:05 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org
Subject: [stable] Patch "drm/radeon: fix PCI ID 5657 to be an RV410" has been added to 2.6.32+drm33-stable
Date: Mon, 15 Nov 2010 16:07:00 +0100
Message-Id: <1289833620-21711-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Dave Airlie <airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/radeon: fix PCI ID 5657 to be an RV410

to the drm-next branch of the 2.6.32+drm33-stable tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-stable tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 35f937fa0736ffc0939d63ad4617e77f66603995 Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Sat, 25 Sep 2010 17:45:50 +1000
Subject: [PATCH] drm/radeon: fix PCI ID 5657 to be an RV410

commit f459ffbdfd04edb4a8ce6eea33170eb057a5e695 upstream.

fixes https://bugzilla.kernel.org/show_bug.cgi?id=19012

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 include/drm/drm_pciids.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
--
1.7.0.4


Disclaimer: Despite what Greg says, this is a stable tree. It just 
happens to have an unusual starting point of 2.6.33 for all the DRM 
and 2.6.32 for all the rest.
