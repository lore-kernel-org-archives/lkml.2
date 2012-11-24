Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab2KXAcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:32:35 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:60673 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2KXA1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:08 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/24] MAINTAINERS: remove arch/arm/common/time-acorn.c
Date: Fri, 23 Nov 2012 22:26:26 -0200
Message-Id: <1353716808-16375-3-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to arch/arm/mach-rpc/time.c by commit a1be5d6 (ARM:
riscpc: move time-acorn.c to mach-rpc), and the pattern for
arch/arm/mach-rpc/ already exists.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2fc7af..041872a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1050,7 +1050,6 @@ M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
-F:	arch/arm/common/time-acorn.c
 F:	arch/arm/include/asm/hardware/entry-macro-iomd.S
 F:	arch/arm/include/asm/hardware/ioc.h
 F:	arch/arm/include/asm/hardware/iomd.h
-- 
1.7.11.7

