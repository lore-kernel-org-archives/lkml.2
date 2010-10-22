Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab0JVSY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58612 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab0JVSYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=vHypjGcWHDd/LS63LasZ4+ubVPTOXnWW+ikJPxPls7v2ufrPPjcYrFbFDlg4LknIvw
         v3SRnAMhxpb9pjw+E/uGEjRMCMHUNojOXqBmr+3MXUGVszuq5HL993uZogbnkAXKBp6q
         aXah9C/CaYtcMik2AMc0QD+Mob6y6TlRCdyDI=
Message-ID: <4CC1D6C7.2030207@gmail.com>
Date: Fri, 22 Oct 2010 20:24:07 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Li Yi <yi.li@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [RFC][PATCH 2/8] Removal of dead code from arch/blackfin/kernel/ipipe.c
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 80cbf2ee3a33740641929f23bf9a7d264a2986b4
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Thu Oct 21 23:57:05 2010 +0200

    Removal of dead code from
    arch/blackfin/kernel/ipipe.c
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: Li Yi <yi.li@analog.com>
    CC: <uclinux-dist-devel@blackfin.uclinux.org>
    CC: <linux-kernel@vger.kernel.org>

diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index 1a496cd..8941cca 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -272,13 +272,6 @@ int ipipe_trigger_irq(unsigned irq)
 {
 	unsigned long flags;
 
-#ifdef CONFIG_IPIPE_DEBUG
-	if (irq >= IPIPE_NR_IRQS ||
-	    (ipipe_virtual_irq_p(irq)
-	     && !test_bit(irq - IPIPE_VIRQ_BASE, &__ipipe_virtual_irq_map)))
-		return -EINVAL;
-#endif
-
 	local_irq_save_hw(flags);
 	__ipipe_handle_irq(irq, NULL);
 	local_irq_restore_hw(flags);
