Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960Ab2CaNua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 09:50:30 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:49407 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750Ab2CaNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 09:50:25 -0400
Message-Id: <201203311350.q2VDoO23007327@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 31 Mar 2012 09:46:03 -0400
Subject: [PATCH] MAINTAINERS: update EDAC information
To: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>
In-Reply-To: <20120331100214.GA7256@aftab>
References: <20120331100214.GA7256@aftab> <mailman.285955.1333149246.6384.bluesmoke-devel@lists.sourceforge.net> <4F7642A9.2070801@tilera.com>
X-OriginalArrivalTime: 31 Mar 2012 13:50:24.0653 (UTC) FILETIME=[38F7B3D0:01CD0F45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bluesmoke mailing list no longer works, so use
linux-edac@vger.kernel.org.  And, use a less restrictive pattern so all
drivers/edac changes go to linux-edac as well.

Borislav suggested I just push this through the tile tree since there
is currently no core edac maintainer (emails to Doug Thompson bounce).

Reviewed-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 MAINTAINERS |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c63a43..1c7c544 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2428,17 +2428,17 @@ F:	fs/ecryptfs/
 
 EDAC-CORE
 M:	Doug Thompson <dougthompson@xmission.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Supported
 F:	Documentation/edac.txt
-F:	drivers/edac/edac_*
+F:	drivers/edac/
 F:	include/linux/edac.h
 
 EDAC-AMD64
 M:	Doug Thompson <dougthompson@xmission.com>
 M:	Borislav Petkov <borislav.petkov@amd.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Supported
 F:	drivers/edac/amd64_edac*
@@ -2446,35 +2446,35 @@ F:	drivers/edac/amd64_edac*
 EDAC-E752X
 M:	Mark Gross <mark.gross@intel.com>
 M:	Doug Thompson <dougthompson@xmission.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/e752x_edac.c
 
 EDAC-E7XXX
 M:	Doug Thompson <dougthompson@xmission.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/e7xxx_edac.c
 
 EDAC-I82443BXGX
 M:	Tim Small <tim@buttersideup.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i82443bxgx_edac.c
 
 EDAC-I3000
 M:	Jason Uhlenkott <juhlenko@akamai.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i3000_edac.c
 
 EDAC-I5000
 M:	Doug Thompson <dougthompson@xmission.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i5000_edac.c
@@ -2503,21 +2503,21 @@ F:	drivers/edac/i7core_edac.c
 EDAC-I82975X
 M:	Ranganathan Desikan <ravi@jetztechnologies.com>
 M:	"Arvind R." <arvino55@gmail.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i82975x_edac.c
 
 EDAC-PASEMI
 M:	Egor Martovetsky <egor@pasemi.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/pasemi_edac.c
 
 EDAC-R82600
 M:	Tim Small <tim@buttersideup.com>
-L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/r82600_edac.c
-- 
1.6.5.2

