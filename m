Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1BWFoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:44:37 -0500
Received: from mail.perches.com ([173.55.12.10]:3856 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab1BWFmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:31 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/18] MAINTAINERS: Update HVC file patterns
Date: Tue, 22 Feb 2011 21:42:01 -0800
Message-Id: <a4668ef19aa2238ced0663763a83e03d72dda15b.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 728674a7e466628df2aeec6d11a2ae1ef968fb67
("tty: move hvc drivers to drivers/tty/hvc/")
moved the files, update the patterns as appropriate.

cc: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6556c9f..a9d971e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2821,7 +2821,7 @@ F:	mm/hwpoison-inject.c
 HYPERVISOR VIRTUAL CONSOLE DRIVER
 L:	linuxppc-dev@lists.ozlabs.org
 S:	Odd Fixes
-F:	drivers/char/hvc_*
+F:	drivers/tty/hvc/
 
 iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
 M:	Peter Jones <pjones@redhat.com>
@@ -6104,7 +6104,7 @@ M:	Chris Metcalf <cmetcalf@tilera.com>
 W:	http://www.tilera.com/scm/
 S:	Supported
 F:	arch/tile/
-F:	drivers/char/hvc_tile.c
+F:	drivers/tty/hvc/hvc_tile.c
 F:	drivers/net/tile/
 
 TLAN NETWORK DRIVER
-- 
1.7.4.rc3

