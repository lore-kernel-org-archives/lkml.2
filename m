Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2HPIAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:00:23 -0400
Received: from cust23-dsl91-135-1.idnet.net ([91.135.1.23]:40173 "EHLO
	drevil.shawell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2HPIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:00:21 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 04:00:21 EDT
From: Steve Glendinning <steve.glendinning@shawell.net>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, trivial@rustcorp.com.au,
        Steve Glendinning <steve.glendinning@shawell.net>
Subject: [PATCH] smsc75xx: add missing entry to MAINTAINERS
Date: Thu, 16 Aug 2012 08:53:38 +0100
Message-Id: <1345103618-22753-1-git-send-email-steve.glendinning@shawell.net>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steve Glendinning <steve.glendinning@shawell.net>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f875890..560bd30 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7289,6 +7289,12 @@ W:	http://www.connecttech.com
 S:	Supported
 F:	drivers/usb/serial/whiteheat*
 
+USB SMSC75XX ETHERNET DRIVER
+M:	Steve Glendinning <steve.glendinning@shawell.net>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/usb/smsc75xx.*
+
 USB SMSC95XX ETHERNET DRIVER
 M:	Steve Glendinning <steve.glendinning@shawell.net>
 L:	netdev@vger.kernel.org
-- 
1.7.9.5

