Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0LIQle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:41:34 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:32955 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0LIQlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:41:11 -0500
X-Greylist: delayed 127330 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 11:41:06 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JQtDtkHdW5rbPmhZ8n2kiYLJMTr+elYJzTz5fHsuKw7JrLli2Dznzpxxx8iEVAZpyx
         NHm7OsxLKs9JRoD5KaAMou665mAFxnHMOZWoZw9TpL2J0/TTZZv+BDYWZH7CKZviAcgK
         vEwU6Q4Ph+4b1nkA0s6EG6ECQpNqjPvTiF3l0=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] Staging: vme_tsi148: use DEFINE_PCI_DEVICE_TABLE
Date: Fri, 10 Dec 2010 01:40:29 +0900
Message-Id: <1291912830-13151-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
References: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 'const struct pci_device_id xxx[]' to 'DEFINE_PCI_DEVICE_TABLE(xxx)'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_tsi148.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 492ddb2d5108..2f5b70986998 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -46,7 +46,7 @@ static int geoid;
 
 static char driver_name[] = "vme_tsi148";
 
-static const struct pci_device_id tsi148_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(tsi148_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_TSI148) },
 	{ },
 };
-- 
1.7.3.3.400.g93cef

