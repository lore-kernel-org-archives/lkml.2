Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab2JWUF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53462 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814Ab2JWUFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:47 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 192/193] tools/lguest: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:25 -0700
Message-Id: <1351022666-6960-193-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/lguest/lguest.txt |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/lguest/lguest.txt b/tools/lguest/lguest.txt
index bff0c55..7203ace 100644
--- a/tools/lguest/lguest.txt
+++ b/tools/lguest/lguest.txt
@@ -29,10 +29,6 @@ Running Lguest:
 
   You will need to configure your kernel with the following options:
 
-  "General setup":
-     "Prompt for development and/or incomplete code/drivers" = Y
-        (CONFIG_EXPERIMENTAL=y)
-
   "Processor type and features":
      "Paravirtualized guest support" = Y
         "Lguest guest support" = Y
@@ -43,10 +39,10 @@ Running Lguest:
 
   "Device Drivers":
      "Block devices"
-        "Virtio block driver (EXPERIMENTAL)" = M/Y
+        "Virtio block driver" = M/Y
      "Network device support"
         "Universal TUN/TAP device driver support" = M/Y
-        "Virtio network driver (EXPERIMENTAL)" = M/Y
+        "Virtio network driver" = M/Y
            (CONFIG_VIRTIO_BLK=m, CONFIG_VIRTIO_NET=m and CONFIG_TUN=m)
 
   "Virtualization"
-- 
1.7.9.5

