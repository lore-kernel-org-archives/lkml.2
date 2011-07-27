Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1G0VtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:18770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab1G0VtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900962"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: gregkh@suse.de, herton.krzesinski@canonical.com, gengor@gentoo.org,
        donald.h.fry@intel.com, wey-yi.w.guy@intel.com, sgruszka@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [64/99] Revert "iwlagn: Support new 5000 microcode."
Message-Id: <20110727214903.75C262403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
This reverts commit 6f63415fc1b690cb50c2ad48ba6e9e6e88e271b4.

It turns out this is not what we want to have happen for the .32 and
.33-longterm kernels as it does not work properly at all.

This was reported by Gentoo, Arch, and Canonical developers as causing
problems for their users:
	https://bugs.archlinux.org/task/24302
	http://bugs.gentoo.org/show_bug.cgi?id=359445
	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/796336

Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Gordon Malm <gengor@gentoo.org>
Cc: Don Fry <donald.h.fry@intel.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-5000.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ linux-2.6.35.y/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -51,7 +51,7 @@
 #include "iwl-agn-debugfs.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 5
+#define IWL5000_UCODE_API_MAX 2
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
