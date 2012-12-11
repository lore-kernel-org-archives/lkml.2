Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2LKVwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:52:11 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:47060 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab2LKVuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:23 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 14/19] MAINTAINERS: fix Documentation/mei/
Date: Tue, 11 Dec 2012 19:49:56 -0200
Message-Id: <1355262601-4263-15-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation was moved to Documentation/misc-devices/mei/ instead.

Acked-by: "Winkler, Tomas" <tomas.winkler@intel.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fbb9c06..6b9fc9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4022,7 +4022,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	include/uapi/linux/mei.h
 F:	drivers/misc/mei/*
-F:	Documentation/mei/*
+F:	Documentation/misc-devices/mei/*
 
 IOC3 ETHERNET DRIVER
 M:	Ralf Baechle <ralf@linux-mips.org>
-- 
1.7.11.7

