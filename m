Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab1LGQXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933683Ab1LGQXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161219.370201198@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:58 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [056/104] drm/radeon/kms: add some new pci ids
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2ed4d9d648cbd4fb1c232a646dbdbdfdd373ca94 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/drm_pciids.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -197,6 +197,14 @@
 	{0x1002, 0x6770, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6778, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6779, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6840, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6841, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6842, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6843, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6849, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6858, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6859, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6880, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6888, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6889, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \


