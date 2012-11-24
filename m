Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2KXA1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:42 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:48596 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2KXA1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:38 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Jean Delvare <khali@linux-fr.org>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>, linux-i2c@vger.kernel.org
Subject: [PATCH 13/24] MAINTAINERS: fix drivers/i2c/busses/i2c-stub.c
Date: Fri, 23 Nov 2012 22:26:37 -0200
Message-Id: <1353716808-16375-14-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to drivers/i2c/i2c-stub.c by commit 31d178b
(i2c-stub: Move to drivers/i2c).

Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: linux-i2c@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 91feba2..eaf1a59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3667,7 +3667,7 @@ I2C/SMBUS STUB DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
-F:	drivers/i2c/busses/i2c-stub.c
+F:	drivers/i2c/i2c-stub.c
 
 I2C SUBSYSTEM
 M:	Wolfram Sang <w.sang@pengutronix.de>
-- 
1.7.11.7

