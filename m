Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0IWWie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:38:34 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5478 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0IWWid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:33 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 4/9] MIPS: Octeon: Select ZONE_DMA32
Date: Thu, 23 Sep 2010 15:38:11 -0700
Message-Id: <1285281496-24696-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 23 Sep 2010 22:38:32.0971 (UTC) FILETIME=[0D6A0DB0:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give us a nice place to allocate coherent DMA memory for 32-bit
devices.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5526faa..6c33709 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -693,6 +693,7 @@ config CAVIUM_OCTEON_REFERENCE_BOARD
 	select SWAP_IO_SPACE
 	select HW_HAS_PCI
 	select ARCH_SUPPORTS_MSI
+	select ZONE_DMA32
 	help
 	  This option supports all of the Octeon reference boards from Cavium
 	  Networks. It builds a kernel that dynamically determines the Octeon
-- 
1.7.2.2

