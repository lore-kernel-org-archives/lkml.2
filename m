Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0IIW7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:59:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44888 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab0IIWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X8jeAx5xQSA0OUr2sPuwjPql/y8+5iKtxLBioSNwojKwdsH9VUp0w3/QsVYGkXpP74
         MDe9QjgtqkYyTkXWLp7qq0CCX/ccOaUfDv40Lt6HwekySY4ccKBRggtWRY9vaxajq6BI
         UZ6+ztpMYeWzFoAd8woZ+s1q+tUt8Jmba8RLs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 124/223]drivers/pci/quirks.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:31 -0700
Message-Id: <1284071862-8194-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/pci/quirks.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 89ed181..58fc076 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -205,7 +205,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 	PCI_DEVICE_ID_INTEL_82439TX, 	quir
 /*
  *	VIA Apollo KT133 needs PCI latency patch
  *	Made according to a windows driver based patch by George E. Breese
- *	see PCI Latency Adjust on http://www.viahardware.com/download/viatweak.shtm
+ *	see PCI Latency Adjust on http://www.sudhian.com/ 
  *      Also see http://www.au-ja.org/review-kt133a-1-en.phtml for
  *      the info on which Mr Breese based his work.
  *
@@ -996,7 +996,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TOSHIBA,	0x605,	quirk_transparent_bridge)
 /*
  * Common misconfiguration of the MediaGX/Geode PCI master that will
  * reduce PCI bandwidth from 70MB/s to 25MB/s.  See the GXM/GXLV/GX1
- * datasheets found at http://www.national.com/ds/GX for info on what
+ * datasheets found at http://www.national.com/analog for info on what
  * these bits do.  <christer@weinigel.se>
  */
 static void quirk_mediagx_master(struct pci_dev *dev)
-- 
1.7.2.1

