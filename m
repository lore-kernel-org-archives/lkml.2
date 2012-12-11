Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2LKVxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:53:11 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:46188 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab2LKVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:21 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net
Subject: [PATCH 11/19] MAINTAINERS: fix drivers/ieee802154/
Date: Tue, 11 Dec 2012 19:49:53 -0200
Message-Id: <1355262601-4263-12-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
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
index 9bc4861d..6e54716 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3800,7 +3800,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git
 S:	Maintained
 F:	net/ieee802154/
 F:	net/mac802154/
-F:	drivers/ieee802154/
+F:	drivers/net/ieee802154/
 
 IIO SUBSYSTEM AND DRIVERS
 M:	Jonathan Cameron <jic23@cam.ac.uk>
-- 
1.7.11.7

