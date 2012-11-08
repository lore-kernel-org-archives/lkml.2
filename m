Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2KHC4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 21:56:30 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37408 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752593Ab2KHC43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 21:56:29 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/5] Add diagnostics for iomem resources
Date: Wed,  7 Nov 2012 21:55:51 -0500
Message-Id: <1352343356-4006-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.7.12.3
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 3 patches add diagnostics to iomem resource management.
The x86 patch adds a diagnostic for bogus ACPI resource definitions.
Lastly, the issue addressed by the mfd driver patch emerged while
testing the other patches in this series.

Peter Hurley (5):
  kernel: Print resource ranges when expanding overlaps
  kernel: Print resource conflicts for failed requests
  kernel: Print warning when inserting resource [mem 0x00000000]
  x86: acpi: Print warning for malformed host bridge resources
  drivers: mfd: Fix resource request for [mem 0x00000000]

 arch/x86/pci/acpi.c   |  4 ++++
 drivers/mfd/lpc_ich.c |  3 +++
 kernel/resource.c     | 12 ++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

-- 
1.7.12.3

