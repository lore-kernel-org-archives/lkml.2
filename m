Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab0HGHHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:07:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41083 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0HGHG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=gSXEtciP9yM5YxteT73K9q+VYkJXevrYyJPmZFZpRhNu0UAZJ71OcDV+Vgkev6mVl2
         w2SRH+IBA5fzfLRxtOJItdv3EJGvZHgL77mLq8ZneAHsiAwaovy4MVI9XCuMQg4sQERW
         mPwbHQRubE5SzB1/j4zS4WumWgV/rmeHI5/4c=
Subject: [PATCH] staging: xgifb: use DEFINE_PCI_DEVICE_TABLE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 03:06:52 -0400
Message-ID: <1281164812.7976.25.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEFINE_PCI_DEVICE_TABLE() to make xgifb_pci_table const and marked as __devinitconst 


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_main.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index fd1152e..06f62ee 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -46,8 +46,7 @@
 #define XGI_IOTYPE2 __iomem
 #define XGIINITSTATIC static
 
-static struct pci_device_id __devinitdata xgifb_pci_table[] = {
-
+static DEFINE_PCI_DEVICE_TABLE(xgifb_pci_table) = {
 	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_27, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
 	{ PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_40, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-- 
1.7.0.4



