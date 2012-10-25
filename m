Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072Ab2JYJAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:00:36 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:20850 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934647Ab2JYJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:00:33 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll387qFkE=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] x86: remove obsolete comment from asm/xen/hypervisor.h
Date: Thu, 25 Oct 2012 11:00:24 +0200
Message-Id: <1351155624-25512-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 arch/x86/include/asm/xen/hypervisor.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 66d0fff..125f344 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -33,7 +33,6 @@
 #ifndef _ASM_X86_XEN_HYPERVISOR_H
 #define _ASM_X86_XEN_HYPERVISOR_H
 
-/* arch/i386/kernel/setup.c */
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
-- 
1.7.12.4

