Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619Ab1LPTv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:51:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932759Ab1LPTub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:02 2011
Message-Id: <20111216194602.072099777@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [49/53] drm/radeon/kms: add some new pci ids
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cd5cfce856684e13b9b57d46b78bb827e9c4da3c upstream.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=43739

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/drm_pciids.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -182,8 +182,11 @@
 	{0x1002, 0x6748, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6749, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6750, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6751, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6758, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6759, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x675B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x675D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x675F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6761, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
@@ -195,8 +198,10 @@
 	{0x1002, 0x6767, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6768, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6770, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6772, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6778, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6779, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x677B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6840, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6841, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6842, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
@@ -246,6 +251,7 @@
 	{0x1002, 0x68f2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CEDAR|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68f8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CEDAR|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68f9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CEDAR|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x68fa, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CEDAR|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68fe, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CEDAR|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x7100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R520|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x7101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R520|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
@@ -488,6 +494,8 @@
 	{0x1002, 0x9647, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x9648, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x964a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x964b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x964c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x964e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x964f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_SUMO|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP},\
 	{0x1002, 0x9710, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS880|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
@@ -502,6 +510,8 @@
 	{0x1002, 0x9805, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9806, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9807, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9808, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9809, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0, 0, 0}
 
 #define r128_PCI_IDS \


