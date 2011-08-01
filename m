Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1HAX0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab1HAXZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:54 2011
Message-Id: <20110801232054.311639582@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [37/70] drm/radeon/kms: add new NI pci ids
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit e3c1620434ac77b618ce74c024ace3559602ac99 upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/drm_pciids.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -182,6 +182,7 @@
 	{0x1002, 0x6750, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6758, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6759, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x675F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TURKS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6761, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6762, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
@@ -192,6 +193,7 @@
 	{0x1002, 0x6767, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6768, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6770, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6778, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6779, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CAICOS|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6880, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6888, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_CYPRESS|RADEON_NEW_MEMMAP}, \


