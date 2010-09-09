Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab0IIWpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:45:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61888 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab0IIWo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gc2JFEgLICi2Q0npkAFmneZMF5LeUaJWP5yJqNeYg2PwhVg7/XKTEZocSadxEkPB8Q
         vaFS2+xrMdj7usR5OmwL5L7ldH/EHuSpgAHFFQoD0EP1vegp1BrYW/MM5NDVYOBmKxom
         MmveX1L9Hk5RFVxwzXukfleEGpwDMUpyP/jBs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 202/223]drivers/uio/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:45:01 -0700
Message-Id: <1284072309-8452-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
References: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/uio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 1da73ec..e8cb825 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -19,7 +19,7 @@ config UIO_CIF
 	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
 	  driver requires a userspace component that handles all of the
 	  heavy lifting and can be found at:
-	  	http://www.osadl.org/projects/downloads/UIO/user/cif-*
+	  http://www.osadl.org/projects/downloads/UIO/user/	
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called uio_cif.
-- 
1.7.2.1

