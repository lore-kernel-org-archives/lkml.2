Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194Ab0HGGjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:39:41 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47409 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab0HGGjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=o6RlzomlxhR4JMCV/eOJ3sBxgeyuBdQEcDVNOci11SC79rHkTXCaAz2ItTVvC/ZdEz
         Q4wyIxLF5/QvnpI1s6HHF+ziDVWhEueMv6s9GmWP6SJ6qnptPd8YsbEB1OfxYVxbfZXD
         MURxlea3CMVRxSKrPoIcEKDvw3Ne+ltGs6BuE=
Subject: [PATCH 09/14] staging: comedi (adl_pci9118): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:39:33 -0400
Message-ID: <1281163173.7976.16.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index b0e39cb..a2bd4e6 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -252,9 +252,8 @@ struct boardtype {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pci9118_pci_table) = {
-	{
-	PCI_VENDOR_ID_AMCC, 0x80d9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMCC, 0x80d9) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pci9118_pci_table);
-- 
1.7.0.4



