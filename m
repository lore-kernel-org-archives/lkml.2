Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481Ab2JXIxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:53:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:10001 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041Ab2JXIxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:53:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="159736407"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] Documentation: fixed Documentation/security/00-INDEX
Date: Wed, 24 Oct 2012 11:53:31 +0300
Message-Id: <1351068811-8200-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keys-ecryptfs.txt was missing from 00-INDEX.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 Documentation/security/00-INDEX |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/security/00-INDEX b/Documentation/security/00-INDEX
index eeed1de..414235c 100644
--- a/Documentation/security/00-INDEX
+++ b/Documentation/security/00-INDEX
@@ -12,6 +12,8 @@ apparmor.txt
 	- documentation on the AppArmor security extension.
 credentials.txt
 	- documentation about credentials in Linux.
+keys-ecryptfs.txt
+	- description of the encryption keys for the ecryptfs filesystem.
 keys-request-key.txt
 	- description of the kernel key request service.
 keys-trusted-encrypted.txt
-- 
1.7.10.4

