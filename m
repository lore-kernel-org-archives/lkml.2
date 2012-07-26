Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2GZP5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:57:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7827 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab2GZP5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:57:02 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="32691208"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 11/24] xen/arm: introduce CONFIG_XEN on ARM
Date: Thu, 26 Jul 2012 16:33:53 +0100
Message-ID: <1343316846-25860-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/Kconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a91009c..9c54cb4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2228,6 +2228,16 @@ config NEON
 	  Say Y to include support code for NEON, the ARMv7 Advanced SIMD
 	  Extension.
 
+config XEN_DOM0
+	def_bool y
+
+config XEN
+	bool "Xen guest support on ARM"
+	depends on ARM && OF
+	select XEN_DOM0
+	help
+	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
+
 endmenu
 
 menu "Userspace binary formats"
-- 
1.7.2.5

