Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0CSUrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:47:04 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33944 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab0CSUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:46:58 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 3/4] x86: export vmware_platform() symbol
To: linux-kernel@vger.kernel.org
Cc: pv-drivers@vmware.com, Alok Kataria <akataria@vmware.com>,
       Saileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 19 Mar 2010 13:46:57 -0700
Message-ID: <20100319204657.4418.50976.stgit@localhost.localdomain>
In-Reply-To: <20100319204628.4418.84674.stgit@localhost.localdomain>
References: <20100319204628.4418.84674.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export vmware_platform() symbol which is needed by vmware_balloon driver.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

 arch/x86/kernel/cpu/vmware.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 1cbed97..dfdb4db 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/dmi.h>
+#include <linux/module.h>
 #include <asm/div64.h>
 #include <asm/vmware.h>
 #include <asm/x86_init.h>
@@ -101,6 +102,7 @@ int vmware_platform(void)
 
 	return 0;
 }
+EXPORT_SYMBOL(vmware_platform);
 
 /*
  * VMware hypervisor takes care of exporting a reliable TSC to the guest.

