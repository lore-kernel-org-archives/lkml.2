Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab2LJNoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:44:18 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35726 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab2LJNoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:44:12 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH v4 7/7] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Date: Mon, 10 Dec 2012 14:42:36 +0100
Message-Id: <1355146956-6009-8-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

The sta2x11 I/O Hub is a bridge from PCIe to AMBA. It reuses a number
of amba drivers and needs to activate core bus support.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5f67642..0659e7b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -521,6 +521,7 @@ config STA2X11
 	select SWIOTLB
 	select MFD_STA2X11
 	select ARCH_REQUIRE_GPIOLIB
+	select ARM_AMBA
 	default n
 	---help---
 	  This adds support for boards based on the STA2X11 IO-Hub,
@@ -2237,6 +2238,9 @@ config GEOS
 
 endif # X86_32
 
+config ARM_AMBA
+        bool
+
 config AMD_NB
 	def_bool y
 	depends on CPU_SUP_AMD && PCI
-- 
1.7.10.4

