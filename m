Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1BPATU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:19:20 -0500
Received: from kroah.org ([198.145.64.141]:38801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab1BPATN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:29 2011
Message-Id: <20110216001429.674917388@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chun-Yi Lee <jlee@novell.com>, Chien-Chia Chen <machen@novell.com>
Subject: [046/272] Staging: rt2860: fix previous patch error
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chien-Chia Chen <machen@novell.com>

commit 1f0613158ea14b399fd7a16470630a729ba9d0c3 upstream.

Somehow Greg messed up the last patch and missed a chunk.  This patch
contains the missing chunk.

Acked-by: Chun-Yi Lee <jlee@novell.com>
Signed-off-by: Chien-Chia Chen <machen@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/chips/rt30xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rt2860/chips/rt30xx.c
+++ b/drivers/staging/rt2860/chips/rt30xx.c
@@ -441,7 +441,7 @@ void RT30xxReverseRFSleepModeSetup(struc
 
 		/* VCO_IC, RF R7 register Bit 4 & Bit 5 to 1 */
 		RT30xxReadRFRegister(pAd, RF_R07, &RFValue);
-		RFValue |= 0x30;
+		RFValue |= 0x20;
 		RT30xxWriteRFRegister(pAd, RF_R07, RFValue);
 
 		/* Idoh, RF R9 register Bit 1, Bit 2 & Bit 3 to 1 */


