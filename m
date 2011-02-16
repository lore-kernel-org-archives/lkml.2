Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab1BPAZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:25:23 -0500
Received: from kroah.org ([198.145.64.141]:49860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757691Ab1BPAZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:50 2011
Message-Id: <20110216001450.187833816@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [251/272] drm/radeon: remove 0x4243 pci id
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 63a507800c8aca5a1891d598ae13f829346e8e39 upstream.

0x4243 is a PCI bridge, not a GPU.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=33815

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/drm_pciids.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -28,7 +28,6 @@
 	{0x1002, 0x4156, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV350}, \
 	{0x1002, 0x4237, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP}, \
 	{0x1002, 0x4242, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
-	{0x1002, 0x4243, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R200}, \
 	{0x1002, 0x4336, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS100|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4337, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \
 	{0x1002, 0x4437, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS200|RADEON_IS_IGP|RADEON_IS_MOBILITY}, \


