Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab0KLLO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:14:57 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:51081 "EHLO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0KLLO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:14:56 -0500
Subject: [PATCH 08/17] staging/vme/tsi148: remove unreachable line
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:14:54 +0000
Message-ID: <20101112111454.11631.17872.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/bridges/vme_tsi148.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 70c9e41..e79a5fa 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2480,7 +2480,6 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-	vme_unregister_bridge(tsi148_bridge);
 err_reg:
 	tsi148_crcsr_exit(tsi148_bridge, pdev);
 err_crcsr:


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
