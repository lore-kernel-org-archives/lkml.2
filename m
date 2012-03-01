Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312Ab2CANa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:30:56 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62287 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966247Ab2CANay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:30:54 -0500
Date: Thu, 1 Mar 2012 14:28:36 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 1/4] x86: add NO_IRQ macro
Message-ID: <6bda7538144dce0bf5780df3d0601147dae753b5.1330607068.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1330607068.git.rubini@gnudd.com>
In-Reply-To: <cover.1330607068.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to compile AMBA drivers. Most architectures define
NO_IRQ as -1, and this does the same for the PC.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/x86/include/asm/irq.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index ba870bb..c9072f5 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -10,6 +10,8 @@
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
 
+#define NO_IRQ	(-1)
+
 static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
-- 
1.7.7.2
