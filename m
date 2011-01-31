Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1AaVVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:21:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41405 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1AaVVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:21:21 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH V2] MAINTAINERS: add second list for IRDA
Date: Mon, 31 Jan 2011 22:21:46 +0100
Message-Id: <1296508906-14644-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irda-users-list is currently almost dead and subscribers-only. Adding
netdev increases the audience which might help to not overlook a bugreport
again.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Samuel Ortiz <samuel@sortiz.org>
---

It would be easier for Samuel if it went via trivial.

 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9d12977..4ff8659 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3420,6 +3420,7 @@ F:	net/ipx/
 IRDA SUBSYSTEM
 M:	Samuel Ortiz <samuel@sortiz.org>
 L:	irda-users@lists.sourceforge.net (subscribers-only)
+L:	netdev@vger.kernel.org
 W:	http://irda.sourceforge.net/
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/irda-2.6.git
-- 
1.7.2.3

