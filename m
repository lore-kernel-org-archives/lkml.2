Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0LIQl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:41:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35378 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab0LIQlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z0QAFj2V5rd/hcNYp16oufqqC3LhAK04C9zgVaYf4XbP09tOT8Pgn/FhU5J98/ILN9
         aNCFTkwHs0t6nSuooysoObqDPFBw5SSXmaTElZzyp0JMVPaW2SSFOC12InZ3bSkko0C0
         qlCGJWDB/RiMadkLys//X4j0zwu0Bm//DR6k8=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] Staging: phison: use DEFINE_PCI_DEVICE_TABLE
Date: Fri, 10 Dec 2010 01:40:28 +0900
Message-Id: <1291912830-13151-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
References: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 'const struct pci_device_id xxx[]' to 'DEFINE_PCI_DEVICE_TABLE(xxx)'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/phison/phison.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 677152044f45..683657cb21f5 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -69,7 +69,7 @@ static int phison_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-static const struct pci_device_id phison_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(phison_pci_tbl) = {
 	{ PCI_VENDOR_ID_PHISON, PCI_DEVICE_ID_PS5000, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 0 },
 	{ 0, },
-- 
1.7.3.3.400.g93cef

