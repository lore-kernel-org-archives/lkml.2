Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab0HGGfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:35:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44339 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0HGGfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=CYL5Nj9M2P6A6A71IQAVdk0+leEw8tkBPzuHRkHzK8n0TKBw8EKZcTvJob6g5fBk9y
         uPxOOR+1k2PpH/EIo7RKUdRMYjxS6JcI+oHHp9OcQY17KqZkYXPVvvPZTpBF0mpEVr/m
         QmRTKsTnrBHTBTGzmspNlJzOsuZGkbixBoT6s=
Subject: [PATCH 04/14] staging: comedi (rtd520): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:35:07 -0400
Message-ID: <1281162907.7976.11.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/rtd520.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 0367d2b..5858d97 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -329,10 +329,9 @@ static const struct rtdBoard rtd520Boards[] = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(rtd520_pci_table) = {
-	{
-	PCI_VENDOR_ID_RTD, 0x7520, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_RTD, 0x4520, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x7520) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_RTD, 0x4520) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, rtd520_pci_table);
-- 
1.7.0.4



