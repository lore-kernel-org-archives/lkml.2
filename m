Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab0HGGbR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:31:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54799 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0HGGbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=royRqKTJ8pgu6CXE89uwTopqXQXYiyvPf0ubYqOELAxBNX8T+xn+FbKZTTWOBXi1ZI
         qEnuK4sFVzvopsvlqYNJR8bpuyi2cjLdmo2SawM18odfYF+zNjauV+oKIFGemPUc+81v
         Hy+/4qs8EIW7/GU7Al1rrx03AP3VG6iMPUxdo=
Subject: [PATCH 01/14] staging: comedi (cb_pcidas): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:31:07 -0400
Message-ID: <1281162667.7976.6.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first of a patch series that uses PCI_DEVICE() macro for pci table entries on comedi drivers and thus improving readability.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 6530b6c..3275fc5 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -377,16 +377,15 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(cb_pcidas_pci_table) = {
-	{
-	PCI_VENDOR_ID_CB, 0x0001, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x000f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0019, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x001c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x004c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x001a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x001b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0001) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x000f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0010) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0019) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001c) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x004c) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001a) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x001b) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, cb_pcidas_pci_table);
-- 
1.7.0.4





