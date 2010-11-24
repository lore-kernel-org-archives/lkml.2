Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0KXT7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:59:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47194 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932087Ab0KXT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:59:10 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/12] sep: cant is an angular inclination
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:38:54 +0000
Message-ID: <20101124193850.16425.60027.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

So use can't instead.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 9c16558..ebe7a90 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -98,7 +98,7 @@ static int sep_load_firmware(struct sep_device *sep)
 
 	error = request_firmware(&fw, res_name, &sep->pdev->dev);
 	if (error) {
-		dev_warn(&sep->pdev->dev, "cant request resident fw\n");
+		dev_warn(&sep->pdev->dev, "can't request resident fw\n");
 		return error;
 	}
 
@@ -3280,7 +3280,7 @@ static int sep_callback(unsigned long sep_context_pointer)
 							&rar_end_address);
 
 	if (error) {
-		dev_warn(&sep->pdev->dev, "mrst cant get rar region\n");
+		dev_warn(&sep->pdev->dev, "mrst can't get rar region\n");
 		goto end_function;
 	}
 
@@ -3417,7 +3417,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		sep->rar_addr = dma_alloc_coherent(NULL,
 			sep->rar_size, &sep->rar_bus, GFP_KERNEL);
 		if (sep->rar_addr == NULL) {
-			dev_warn(&sep->pdev->dev, "cant allocate mfld rar\n");
+			dev_warn(&sep->pdev->dev, "can't allocate mfld rar\n");
 			error = -ENOMEM;
 			goto end_function_deallocate_sep_shared_area;
 		}

