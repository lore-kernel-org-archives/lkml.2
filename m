Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1CFK1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 05:27:33 -0500
Received: from chipmunk.wormnet.eu ([195.195.131.226]:36384 "EHLO
	chipmunk.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1CFK1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 05:27:31 -0500
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Mar 2011 05:27:31 EST
Date: Sun, 6 Mar 2011 10:18:37 +0000
From: Alexander Clouter <alex@digriz.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: inflict self with ARM/ts78xx-setup platform
 maintainership
Message-ID: <20110306101836.GH22117@chipmunk>
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
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

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
