Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1COLOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:14:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55449 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab1COLOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:14:34 -0400
Message-Id: <20110315111428.230493908@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:15 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [patch 8/8] tpm: Fix a typo
References: <20110315111307.895085413@linux.vnet.ibm.com>
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

