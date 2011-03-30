Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab1C3QQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:16:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54059 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3QOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:24 -0400
Message-Id: <20110330161419.859336395@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:34 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH V2 12/12] tpm: Fix a typo
References: <20110330161322.015113054@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_fix_typo.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Index: linux-2.6/drivers/char/tpm/tpm.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.c
+++ linux-2.6/drivers/char/tpm/tpm.c
@@ -615,7 +615,7 @@ void tpm_continue_selftest(struct tpm_ch
 	u8 data[] = {
 		0, 193,			/* TPM_TAG_RQU_COMMAND */
 		0, 0, 0, 10,		/* length */
-		0, 0, 0, 83,		/* TPM_ORD_GetCapability */
+		0, 0, 0, 83,		/* TPM_ORD_ContinueSelfTest */
 	};
 
 	tpm_transmit(chip, data, sizeof(data));

