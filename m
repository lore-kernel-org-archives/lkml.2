Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1GIVwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:52:53 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:53779 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab1GIVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:52:52 -0400
Date: Sat, 9 Jul 2011 15:52:51 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
cc: khilman@ti.com, tony@atomide.com
Subject: [PATCH] MAINTAINERS: add Kevin Hilman as the omap_device
 maintainer
Message-ID: <alpine.DEB.2.00.1107091551350.15984@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, plat-omap/omap_device.c is used as the interface between
the core Linux PM code (such as the system suspend and PM runtime
code) and the internal OMAP power management infrastructure (such as
the hwmod code, clockdomains, powerdomains, clocks, etc.)

Kevin's doing most of the interaction with the core Linux PM people on
this, so it makes sense for him to be the maintainer.

Later, if we add some omap_bus code and convert omap_device into a proper 
Linux device, I suggest that maintainership of this piece should return to 
Tony.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kevin Hilman <khilman@ti.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ae563fa..4b5a5dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4534,6 +4534,7 @@ M:	Kevin Hilman <khilman@ti.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*pm*
+F:	arch/arm/plat-omap/omap_device.c
 
 OMAP POWERDOMAIN/CLOCKDOMAIN SOC ADAPTATION LAYER SUPPORT
 M:	Rajendra Nayak <rnayak@ti.com>
-- 
1.7.5.4

