Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0KXTxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:53:45 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48613 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753172Ab0KXTxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:53:44 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/12] sep: minimal fix for wrong include
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:33:26 +0000
Message-ID: <20101124192357.16425.22786.stgit@bob.linux.org.uk>
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

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver_config.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index 686a353..68688cb 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -421,7 +421,7 @@ struct RAR_buffer {
 
 #else /* using real RAR_REGISTER */
 
-#include "../rar_register/rar_register.h"
+#include <linux/rar_register.h>
 
 #endif  /* CONFIG_RAR_REGISTER */
 

