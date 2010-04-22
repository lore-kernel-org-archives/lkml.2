Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0DVT7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:59:41 -0400
Received: from kroah.org ([198.145.64.141]:59368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab0DVT7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:05 2010
Message-Id: <20100422195405.118194860@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:52:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [002/139] drm/radeon: add new RS880 pci id
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 338e2b1d571e4873908b199c90d6a31f65137fe3 upstream.

This should go to 2.6.33 stable as well.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/drm_pciids.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -375,6 +375,7 @@
 	{0x1002, 0x9712, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS880|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9713, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS880|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9714, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS880|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9715, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RS880|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0, 0, 0}
 
 #define r128_PCI_IDS \


