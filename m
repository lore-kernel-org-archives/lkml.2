Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab0GUFIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:08:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab0GUE5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ESSYoDjxG+/ZbWbxiJ5hPKKqOJ2ie6/ZdSM7xM7u2U2CdeqsBCCIFC/YwjZrtcoQEk
         d8IxmwNRlOxEDBGInQ3ebS2CdQsbrooHnSH8DeLjdrVxeusyhrgxkv5haZYyougXqx1X
         6KW2nFuguvqTpy5YJu9zfh7UEolzTfIDO6jLg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 101/101]Documentation/scsi/ChangeLog.megaraid update web address.
Date: Tue, 20 Jul 2010 21:56:51 -0700
Message-Id: <1279688215-29628-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/ChangeLog.megaraid |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/ChangeLog.megaraid b/Documentation/scsi/ChangeLog.megaraid
index 38e9e7c..5e07d32 100644
--- a/Documentation/scsi/ChangeLog.megaraid
+++ b/Documentation/scsi/ChangeLog.megaraid
@@ -215,7 +215,7 @@ Older Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
 
 3.	Convert pci_module_init to pci_register_driver
 	Convert from pci_module_init to pci_register_driver
-	(from:http://kerneljanitors.org/TODO)
+	(from:http://kernelnewbies.org/KernelJanitors/TODO)
 		- Signed-off-by: Domen Puncer <domen@coderock.org>
 
 4.	Use the pre defined DMA mask constants from dma-mapping.h
-- 
1.7.1.rc1.21.gf3bd6

