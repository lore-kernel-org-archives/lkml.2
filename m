Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1EFAOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:14:00 -0400
Received: from kroah.org ([198.145.64.141]:32993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab1EFANo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:11 2011
Message-Id: <20110506001211.020508985@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:11:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [patch 38/38] drm/radeon/kms: add some new pci ids
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit e2c85d8e3974c9041ad7b080846b28d2243e771b upstream.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/drm_pciids.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -153,6 +153,7 @@
 	{0x1002, 0x6729, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BARTS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6738, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BARTS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6739, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BARTS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x673e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_BARTS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6740, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6741, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6742, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
@@ -185,6 +186,7 @@
 	{0x1002, 0x688D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6898, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6899, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x689b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x689c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HEMLOCK|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x689d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_HEMLOCK|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x689e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \
@@ -195,7 +197,9 @@
 	{0x1002, 0x68b0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_JUNIPER|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68b8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_JUNIPER|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68b9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_JUNIPER|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x68ba, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_JUNIPER|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68be, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_JUNIPER|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x68bf, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_JUNIPER|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68c0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_REDWOOD|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68c1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_REDWOOD|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x68c7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_REDWOOD|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \


