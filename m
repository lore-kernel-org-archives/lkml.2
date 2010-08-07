Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794Ab0HGGnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:43:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48699 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244Ab0HGGnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=dzmBvvCZiVjA8xoz/2122uHKjE/7LRYaK2o7vfhbTWyZ+jmbnOoz6L5zjfWEPWrieA
         PJsrl9N3rtpf7yTAoKMWQ1xFrsb3FU0Fz9EZAIIUvNdc1Aw2x34ymrNvdSVKWV2eEYr9
         8dwBxfJgOEP/mOQUiif9SODBn6CJChX64+xrI=
Subject: [PATCH 13/14] staging: comedi (cb_pcidas64): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:42:55 -0400
Message-ID: <1281163375.7976.20.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |   60 +++++++++-----------------
 1 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 53e7015..9b1dd3c 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1028,46 +1028,26 @@ static const struct pcidas64_board pcidas64_boards[] = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pcidas64_pci_table) = {
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x001d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x001e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0035, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0036, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0037, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0052, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x005d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x005e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x005f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0061, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0062, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0063, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0064, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0066, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0067, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0068, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x006f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0078, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	PCI_VENDOR_ID_COMPUTERBOARDS, 0x0079, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x001d) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x001e) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0035) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0036) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0037) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0052) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005d) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005e) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x005f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0061) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0062) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0063) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0064) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0066) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0067) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0068) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x006f) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0078) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTERBOARDS, 0x0079) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pcidas64_pci_table);
-- 
1.7.0.4



