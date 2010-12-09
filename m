Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0LIQlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:41:18 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:32955 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0LIQlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:41:13 -0500
X-Greylist: delayed 127330 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 11:41:06 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bgSj9yyyDuyEcBB5M5P8/Q8hXXGhaMMMaINbGl+OmTKBRNv5NjmxWiaR0tYxzJp05+
         WCQ7DKHxTj7SIeaov5L0v0hD8GyM2VDLoso8MFKtp/6yQWIh4Wh32ltYCtlluuh69rKU
         jd12XfKozJp5PzBLr71JHuValvmYY2ZymGPjo=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] Staging: vme_ca91cx42: use DEFINE_PCI_DEVICE_TABLE
Date: Fri, 10 Dec 2010 01:40:30 +0900
Message-Id: <1291912830-13151-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
References: <1291912830-13151-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 'const struct pci_device_id xxx[]' to 'DEFINE_PCI_DEVICE_TABLE(xxx)'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 4d745623211b..7db44fe32762 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -44,7 +44,7 @@ static int geoid;
 
 static char driver_name[] = "vme_ca91cx42";
 
-static const struct pci_device_id ca91cx42_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(ca91cx42_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_CA91C142) },
 	{ },
 };
-- 
1.7.3.3.400.g93cef

