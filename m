Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1FPHMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:12:00 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46097 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108Ab1FPHLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:43 -0400
X-Sasl-enc: rPWPnD7oL6DQ1RBSVCo/2G4KKK0QsBdU1t/y3o+vVE/y 1308208303
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:12 2011
Message-Id: <20110616002912.375969379@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Gordon Malm <gengor@gentoo.org>, Don Fry <donald.h.fry@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [85/85] [PATCH] Revert "iwlagn: Support new 5000 microcode."
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -48,7 +48,7 @@
 #include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 5
+#define IWL5000_UCODE_API_MAX 2
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */


