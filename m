Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2KXA1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:52 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:57294 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2KXA1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:48 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 17/24] MAINTAINERS: fix Documentation/mei/
Date: Fri, 23 Nov 2012 22:26:41 -0200
Message-Id: <1353716808-16375-18-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation was moved to Documentation/misc-devices/mei/ instead.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e7a2349..fc646ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4020,7 +4020,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	include/uapi/linux/mei.h
 F:	drivers/misc/mei/*
-F:	Documentation/mei/*
+F:	Documentation/misc-devices/mei/*
 
 IOC3 ETHERNET DRIVER
 M:	Ralf Baechle <ralf@linux-mips.org>
-- 
1.7.11.7

