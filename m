Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab2LMOjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:39:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab2LMOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 134/241] drm/radeon: add new SI pci id
Date: Thu, 13 Dec 2012 11:58:19 -0200
Message-Id: <1355407206-17100-135-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0181bd5dea2ed0696f84591a92da0b6a1f1a2e62 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/drm/drm_pciids.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index fc0f7cc..e2b7fdf 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -210,6 +210,7 @@
 	{0x1002, 0x6798, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6799, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x679A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x679B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x679E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x679F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6800, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
-- 
1.7.9.5

