Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761656Ab2FHFId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:08:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43281 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758979Ab2FHFHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:37 -0400
Message-Id: <20120608041851.525164014@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 79/82] drm/radeon/kms: add new BTC PCI ids
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit a2bef8ce826dd1e787fd8ad9b6e0566ba59dab43 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/drm/drm_pciids.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index c5b0d8c..86c4cf9 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -181,6 +181,7 @@
 	{0x1002, 0x6747, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6748, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6749, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x674A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6750, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6751, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6758, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
@@ -198,6 +199,7 @@
 	{0x1002, 0x6767, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6768, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6770, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6771, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6772, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6778, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6779, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \


