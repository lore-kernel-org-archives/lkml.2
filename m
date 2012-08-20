Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2HTD6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:58:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2HTD6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 13/32] drm/radeon: add some new SI pci ids
Date: Sun, 19 Aug 2012 20:57:09 -0700
Message-Id: <20120820035649.712278106@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2f292004dd1fb005788dc0a9cdd5559812ed866e upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/drm_pciids.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -217,9 +217,12 @@
 	{0x1002, 0x6800, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6801, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6802, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6806, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6808, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6809, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6810, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6816, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6817, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6818, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6819, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6820, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_VERDE|RADEON_IS_MOBILITY|RADEON_NEW_MEMMAP}, \


