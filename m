Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab1CXVqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:46:05 -0400
Received: from chipmunk.wormnet.eu ([195.195.131.226]:42113 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587Ab1CXVp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:45:59 -0400
Date: Thu, 24 Mar 2011 21:45:55 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH repost] MAINTAINERS: add self for ARM/ts78xx-setup platform
Message-ID: <20110324214555.GE25446@chipmunk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f99e12..4e81034 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -856,6 +856,13 @@ F:	arch/arm/mach-mv78xx0/
 F:	arch/arm/mach-orion5x/
 F:	arch/arm/plat-orion/
 
+ARM/Orion SoC/Technologic Systems TS-78xx platform support
+M:	Alexander Clouter <alex@digriz.org.uk>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+W:	http://www.digriz.org.uk/ts78xx/kernel
+S:	Maintained
+F:	arch/arm/mach-orion5x/ts78xx-*
+
 ARM/MIOA701 MACHINE SUPPORT
 M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.7.4.1
