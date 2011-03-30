Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab1C3VHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:51403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365Ab1C3VHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133069"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [82/275] drm/radeon: remove 0x4243 pci id
Message-Id: <20110330210520.08B9E3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 63a507800c8aca5a1891d598ae13f829346e8e39 upstream.

0x4243 is a PCI bridge, not a GPU.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=33815

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/drm/drm_pciids.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.35.y/include/drm/drm_pciids.h
===================================================================
--- linux-2.6.35.y.orig/include/drm/drm_pciids.h	2011-03-29 22:51:37.391766406 -0700
+++ linux-2.6.35.y/include/drm/drm_pciids.h	2011-03-29 23:02:59.854303898 -0700
@@ -28,7 +28,6 @@
 	{0x1002, 0x4156, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV350}, \
 	{0x1002, 0x4237, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP}, \
 	{0x1002, 0x4242, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
-	{0x1002, 0x4243, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
 	{0x1002, 0x4336, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS100|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4337, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4437, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
