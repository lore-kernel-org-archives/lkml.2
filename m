Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1ABHkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:40:41 -0500
Received: from mail.windriver.com ([147.11.1.11]:36662 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1ABHYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 191/260] drm/radeon: fix PCI ID 5657 to be an RV410
Date: Sun,  2 Jan 2011 02:18:07 -0500
Message-Id: <1293952756-15010-192-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:39.0916 (UTC) FILETIME=[FA5354C0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit f459ffbdfd04edb4a8ce6eea33170eb057a5e695 upstream.

fixes https://bugzilla.kernel.org/show_bug.cgi?id=19012

cc: stable@kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/drm/drm_pciids.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index 3a9940e..883c1d4 100644
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
1.7.3.3

