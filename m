Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab1C3WG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:06:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:35488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933162Ab1C3VGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733938"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: arvid.picciani@nokia.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [28/275] USB: cdc-acm: Adding second ACM channel support for Nokia N8
Message-Id: <20110330210423.2C9F93E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Arvid Ephraim Picciani <arvid.picciani@nokia.com>

commit 721d92fc6373dee15846216f9d178ec240ec0fd7 upstream.

This adds the N8 to the list of devices in cdc-acm, in order to get the
secondary ACM device exposed.

In the spirit of:
http://kerneltrap.org/mailarchive/linux-usb/2010/9/4/6264554

Signed-off-by: Arvid Ephraim Picciani <arvid.picciani@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/class/cdc-acm.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/usb/class/cdc-acm.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/class/cdc-acm.c	2011-03-29 22:51:57.312256691 -0700
+++ linux-2.6.35.y/drivers/usb/class/cdc-acm.c	2011-03-29 23:53:55.425119487 -0700
@@ -1613,6 +1613,7 @@
 	{ NOKIA_PCSUITE_ACM_INFO(0x0154), }, /* Nokia 5800 XpressMusic */
 	{ NOKIA_PCSUITE_ACM_INFO(0x04ce), }, /* Nokia E90 */
 	{ NOKIA_PCSUITE_ACM_INFO(0x01d4), }, /* Nokia E55 */
+	{ NOKIA_PCSUITE_ACM_INFO(0x0302), }, /* Nokia N8 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
