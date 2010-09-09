Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab0IIW6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:58:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44888 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab0IIWhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bpRrQZVE4hy1+9D0bPsTh+zatRIl4sa3Zr8BoRq/zbxe4SPgD0udYP5GCuuBToF9Ee
         x1nRf1O3byDCASm95gf/xyAspQDB86F5LcX+e0wAnHCZYdnv0QsEaRNnIkRy2V7lh1XR
         OJ0DfU8A+TcSaCcSey82rnRzzN1K4HmVcWm30=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 130/223]drivers/scsi/arm/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:37 -0700
Message-Id: <1284071862-8194-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/arm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index a8587f1..53c645a 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -39,7 +39,7 @@ config SCSI_ARXESCSI
 	  HD discs from the then new A5000 on earlier models. This interface
 	  was either sold on its own or with an integral SCSI controller.
 	  Technical details on this NCR53c94-based device are available at
-	  <http://www.cryton.demon.co.uk/acornbits/scsi_arxe.html>
+	  <http://web.archive.org/web/*/http://www.cryton.demon.co.uk/acornbits/scsi_arxe.html>
 	  Say Y here to compile in support for the SCSI controller.
 
 config SCSI_CUMANA_2
-- 
1.7.2.1

