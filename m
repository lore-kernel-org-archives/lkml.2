Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2KSTMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:12:05 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:59943 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2KSTME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:12:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] TTY: let me eat my own cooking
Date: Mon, 19 Nov 2012 20:11:43 +0100
Message-Id: <1353352303-24299-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353352303-24299-1-git-send-email-jslaby@suse.cz>
References: <1353352303-24299-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am the one introducing the most potential bugs. And people should
know the urchin to whip.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 617eca6..18440d0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7426,6 +7426,7 @@ K:	^Subject:.*(?i)trivial
 
 TTY LAYER
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+M:	Jiri Slaby <jslaby@suse.cz>
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
 F:	drivers/tty/
-- 
1.8.0


