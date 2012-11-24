Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2KXAaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:30:03 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:38854 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab2KXA1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:40 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net
Subject: [PATCH 14/24] MAINTAINERS: fix drivers/ieee802154/
Date: Fri, 23 Nov 2012 22:26:38 -0200
Message-Id: <1353716808-16375-15-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This directory was moved to drivers/net/ieee802154/ by commit 31d178b
(drivers/ieee802154: move ieee802154 drivers to net folder).

Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-zigbee-devel@lists.sourceforge.net
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eaf1a59..bd3049f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3798,7 +3798,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git
 S:	Maintained
 F:	net/ieee802154/
 F:	net/mac802154/
-F:	drivers/ieee802154/
+F:	drivers/net/ieee802154/
 
 IIO SUBSYSTEM AND DRIVERS
 M:	Jonathan Cameron <jic23@cam.ac.uk>
-- 
1.7.11.7

