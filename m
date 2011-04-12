Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1DLOiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:10 -0400
Received: from kroah.org ([198.145.64.141]:57574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab1DLOiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.657067489@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [044/105] drm/radeon/kms: add some new ontario pci ids
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 758f231ea280d0e5f01d537f26ad8f5c0e3de1cc upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/drm_pciids.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -458,6 +458,8 @@
 	{0x1002, 0x9803, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9804, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0x1002, 0x9805, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9806, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
+	{0x1002, 0x9807, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PALM|RADEON_NEW_MEMMAP|RADEON_IS_IGP}, \
 	{0, 0, 0}
 
 #define r128_PCI_IDS \


