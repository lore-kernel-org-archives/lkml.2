Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1FMEgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 00:36:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36879 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1FMEgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 00:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=L0zz1qWKBm9L4AY9RI+ZLyt2Mu1o7hGjDdJvgmuNkFCdh8DC8RfnfMmB6E/F6tew+a
         VdjtqIWnphF71IftNIycbC+F/Dz0A9MC+vIXczgLiHGWsHufncITVwzB0ubE6JiQIufg
         mWvEwgCjqdAtrRPioCOQH8EKAwtjpcQK9tXI0=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] Documentation:fix the wrong file position in sched-arch.txt
Date: Mon, 13 Jun 2011 12:35:23 +0800
Message-Id: <1307939723-2953-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch i386 had changed to x86.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 Documentation/scheduler/sched-arch.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
index d43dbcb..28aa107 100644
--- a/Documentation/scheduler/sched-arch.txt
+++ b/Documentation/scheduler/sched-arch.txt
@@ -66,7 +66,7 @@ Your cpu_idle routines need to obey the following rules:
 	    barrier issued (followed by a test of need_resched with
 	    interrupts disabled, as explained in 3).
 
-arch/i386/kernel/process.c has examples of both polling and
+arch/x86/kernel/process.c has examples of both polling and
 sleeping idle functions.
 
 
-- 
1.7.4.1

