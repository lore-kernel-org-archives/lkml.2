Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab1EFAdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:33:35 -0400
Received: from kroah.org ([198.145.64.141]:37547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640Ab1EFA13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:08 2011
Message-Id: <20110506002608.732824823@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Fry <donald.h.fry@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [15/43] iwlagn: Support new 5000 microcode.
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Fry, Donald H <donald.h.fry@intel.com>

commit 41504cce240f791f1e16561db95728c5537fbad9 upstream.

New iwlwifi-5000 microcode requires driver support for API version 5.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -48,7 +48,7 @@
 #include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 2
+#define IWL5000_UCODE_API_MAX 5
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */


