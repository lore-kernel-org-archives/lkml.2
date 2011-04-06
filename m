Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab1DFKPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:15:20 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:50649
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729Ab1DFKPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:15:18 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ875D-01-7VR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] staging: hv_mouse: Fix build error
Date: Wed, 6 Apr 2011 12:14:56 +0200
Message-ID: <1302084896-25250-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler argues about the implictly declared udelay
function. Fix it by adding the appropriate include.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/staging/hv/hv_mouse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 50147f8..9c6d4d2 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -23,6 +23,7 @@
 #include <linux/hiddev.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include <linux/delay.h>
 
 #include "hv_api.h"
 #include "logging.h"
-- 
1.7.1


