Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab2INLk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:40:59 -0400
Received: from smtp.citrix.com ([66.165.176.89]:8685 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab2INLkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:40:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="37874915"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <linaro-dev@lists.linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <tim@xen.org>, <Ian.Campbell@citrix.com>, <konrad.wilk@oracle.com>,
        <Stefano.Stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v4 24/24] MAINTAINERS: add myself as Xen ARM maintainer
Date: Fri, 14 Sep 2012 12:13:26 +0100
Message-ID: <1347621207-11294-24-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fdc0119..3d38291 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7752,6 +7752,13 @@ F:	drivers/xen/
 F:	arch/x86/include/asm/xen/
 F:	include/xen/
 
+XEN HYPERVISOR ARM
+M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+S:	Supported
+F:	arch/arm/xen/
+F:	arch/arm/include/asm/xen/
+
 XEN NETWORK BACKEND DRIVER
 M:	Ian Campbell <ian.campbell@citrix.com>
 L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
-- 
1.7.2.5

