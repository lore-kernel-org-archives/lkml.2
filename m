Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059Ab2J2VgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:36:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:46966 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761045Ab2J2VgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 001/101] drm/radeon: add some new SI PCI ids
Date: Mon, 29 Oct 2012 14:34:14 -0700
Message-Id: <20121029213240.322330854@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b6aa22db7857ab7ed042d6c56b800bfc727cfdff upstream.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/drm/drm_pciids.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -205,6 +205,8 @@
 	{0x1002, 0x6788, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x678A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6790, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6791, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6792, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6798, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6799, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x679A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_TAHITI|RADEON_NEW_MEMMAP}, \
@@ -217,6 +219,7 @@
 	{0x1002, 0x6808, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6809, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6810, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
+	{0x1002, 0x6811, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6816, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6817, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \
 	{0x1002, 0x6818, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PITCAIRN|RADEON_NEW_MEMMAP}, \


