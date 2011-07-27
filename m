Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1G0AfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:17764 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1G0AfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32659216"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: pboettcher@kernellabs.com, steffenbpunkt@googlemail.com, me@boris64.net,
        mchehab@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [14/98] FLEXCOP-PCI: fix __xlate_proc_name-warning for flexcop-pci
Message-Id: <20110727003506.395B12403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Patrick Boettcher <pboettcher@kernellabs.com>

commit b934c20de1398d4a82d2ecfeb588a214a910f13f upstream.

This patch fixes the warning about bad names for sys-fs and other kernel-things. The flexcop-pci driver was using '/'-characters in it, which is not good.
This has been fixed in several attempts by several people, but obviously never made it into the kernel.

Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Steffen Barszus <steffenbpunkt@googlemail.com>
Cc: Boris Cuber <me@boris64.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/dvb/b2c2/flexcop-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/media/dvb/b2c2/flexcop-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/dvb/b2c2/flexcop-pci.c
+++ linux-2.6.35.y/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -38,7 +38,7 @@ MODULE_PARM_DESC(debug,
 	DEBSTATUS);
 
 #define DRIVER_VERSION "0.1"
-#define DRIVER_NAME "Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver"
+#define DRIVER_NAME "flexcop-pci"
 #define DRIVER_AUTHOR "Patrick Boettcher <patrick.boettcher@desy.de>"
 
 struct flexcop_pci {
