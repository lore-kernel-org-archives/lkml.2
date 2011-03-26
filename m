Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381Ab1CZBud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:50:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50669 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934357Ab1CZBu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:50:29 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/uLb9C3p/uGYJsESM6FlP2o3N12EMtjZyJ7Jovi/
	wV70MxfH+uOVvj
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 26/27] staging/wlags49_h2: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:50:01 +0100
Message-Id: <1301104202-16592-26-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
References: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistake in
drivers/staging/wlags49_h2.

WRONG -> RIGHT
accomodate  -> accommodate

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/wlags49_h2/hcf.c |    2 +-
 drivers/staging/wlags49_h2/mdd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index d4bdd3e..bd8d3cc 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -1735,7 +1735,7 @@ DESC_STRCT *descp;	// pointer to start of FrameList
 * - in case encapsulation by the HCF is selected:
 *	  -	The FrameList does not consists of at least 2 Descriptors.
 *	  -	The first databuffer does not contain exactly the (space for) the 802.11 header (== 28 words)
-*	  -	The first databuffer does not have a size to additionally accomodate the 802.3 header and the
+*	  -	The first databuffer does not have a size to additionally accommodate the 802.3 header and the
 *		SNAP header of the frame after encapsulation (== 39 words).
 *	  -	The second databuffer does not contain at least DA, SA and 'type/length' (==14 bytes or 7 words)
 *!! The 2nd part of the list of asserts should be kept in sync with put_frame_lst, in order to get
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index 5aa9eb8..5ce3342 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -851,7 +851,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define HCF_ERR_LEN					0x08	/* buffer size insufficient
 		 								  	 *		  -	IFB_ConfigTable too small
 		 								  	 *		  -	hcf_get_info buffer has a size of 0 or 1 or less than needed
-		 							  		 *			to accomodate all data
+		 							  		 *			to accommodate all data
 		 							  		 *		  -	hcf_put_info: CFG_DLNV_DATA exceeds intermediate
 											 *		  buffer size */
 #define HCF_ERR_INCOMP_PRI			0x09	// primary functions are not compatible
-- 
1.7.3.4

