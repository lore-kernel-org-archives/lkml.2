Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab2HSDCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:02:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:64945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab2HSC5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422072"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 51/74] x86, lto, efi: Mark the efi variable used from assembler __visible
Date: Sat, 18 Aug 2012 19:56:47 -0700
Message-Id: <1345345030-22211-52-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/platform/efi/efi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2dc29f5..02bc41a 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -53,7 +53,7 @@
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
 
-struct efi __read_mostly efi = {
+struct efi __visible __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
 	.acpi20     = EFI_INVALID_TABLE_ADDR,
-- 
1.7.7.6

