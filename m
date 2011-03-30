Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab1C3VIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:41245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516Ab1C3VH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735322"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mjg@redhat.com, carlos@strangeworlds.co.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [134/275] acer-wmi: Fix capitalisation of GUID
Message-Id: <20110330210614.C8DD63E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Matthew Garrett <mjg@redhat.com>

commit bbb706079abe955a9e3f208f541de97d99449236 upstream.

6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3 needs to be
6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3 to match the hardware alias.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/platform/x86/acer-wmi.c
===================================================================
--- linux-2.6.35.y.orig/drivers/platform/x86/acer-wmi.c	2011-03-29 22:51:13.954366111 -0700
+++ linux-2.6.35.y/drivers/platform/x86/acer-wmi.c	2011-03-29 23:54:44.341867828 -0700
@@ -91,7 +91,7 @@
  */
 #define AMW0_GUID1		"67C3371D-95A3-4C37-BB61-DD47B491DAAB"
 #define AMW0_GUID2		"431F16ED-0C2B-444C-B267-27DEB140CF9C"
-#define WMID_GUID1		"6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3"
+#define WMID_GUID1		"6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3"
 #define WMID_GUID2		"95764E09-FB56-4e83-B31A-37761F60994A"
 
 MODULE_ALIAS("wmi:67C3371D-95A3-4C37-BB61-DD47B491DAAB");
