Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab1BQC73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:59:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39415 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1BQC7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bPi7WXmMTPqLpd42zFJfyhvy2GANiv1/QmKhK7TMcfl1MvquIhBwdhsC3vx1ffNewE
         pSNguCfV3FLO6/YTV8oK4OfpyTBx3rf1+A2ei/45dM9/cVBsRzqfFeKKTxJ1F2Yn6y8u
         3gv6HoVeqV4b2Z/hRjNxwN+JxXeTETHEt3fPY=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 10/10] Staging: tidspbridge: fixed casting style issue
Date: Thu, 17 Feb 2011 03:58:54 +0100
Message-Id: <1297911534-31534-10-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-9-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-5-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-6-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-7-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-8-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-9-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 3430418..84b37e2 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -178,7 +178,7 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 	void *dummy_va_addr;
 
 	resources = dev_context->resources;
-	dummy_va_addr = (void*)__get_free_page(GFP_ATOMIC);
+	dummy_va_addr = (void *)__get_free_page(GFP_ATOMIC);
 
 	/*
 	 * Before acking the MMU fault, let's make sure MMU can only
-- 
1.7.1

