Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab2JLXty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 19:49:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38220 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2JLXtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 19:49:50 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, backports@vger.kernel.org, rob@ti.com,
        arnd@arndb.de, davej@redhat.com, airlied@linux.ie, bskeggs@redhat.com,
        alan@lxorguk.ukuu.org.uk, dhowells@redhat.com, tglx@linutronix.de,
        daniel.vetter@ffwll.ch, jbarnes@virtuousgeek.org,
        alexander.deucher@amd.com, paulmck@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/2] uapi: remove trailing spaces
Date: Fri, 12 Oct 2012 16:49:32 -0700
Message-Id: <1350085772-8755-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com>
References: <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

No functional changes.

Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: backports@vger.kernel.org

Cc: Rob Clark <rob@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Jones <davej@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/uapi/asm-generic/siginfo.h |    4 ++--
 include/uapi/asm-generic/statfs.h  |    4 ++--
 include/uapi/drm/radeon_drm.h      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index ba5be7f..34b941ce6 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -252,8 +252,8 @@ typedef struct siginfo {
 
 /*
  * sigevent definitions
- * 
- * It seems likely that SIGEV_THREAD will have to be handled from 
+ *
+ * It seems likely that SIGEV_THREAD will have to be handled from
  * userspace, libpthread transmuting it to SIGEV_SIGNAL, which the
  * thread manager then catches and does the appropriate nonsense.
  * However, everything is written out here so as to not get lost.
diff --git a/include/uapi/asm-generic/statfs.h b/include/uapi/asm-generic/statfs.h
index 0999647..0d79b2f 100644
--- a/include/uapi/asm-generic/statfs.h
+++ b/include/uapi/asm-generic/statfs.h
@@ -36,7 +36,7 @@ struct statfs {
 
 /*
  * ARM needs to avoid the 32-bit padding at the end, for consistency
- * between EABI and OABI 
+ * between EABI and OABI
  */
 #ifndef ARCH_PACK_STATFS64
 #define ARCH_PACK_STATFS64
@@ -57,7 +57,7 @@ struct statfs64 {
 	__statfs_word f_spare[4];
 } ARCH_PACK_STATFS64;
 
-/* 
+/*
  * IA64 and x86_64 need to avoid the 32-bit padding at the end,
  * to be compatible with the i386 ABI
  */
diff --git a/include/uapi/drm/radeon_drm.h b/include/uapi/drm/radeon_drm.h
index 4766c0f..48b0db3 100644
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -229,7 +229,7 @@ typedef union {
 #	define R300_WAIT_3D		0x2
 /* these two defines are DOING IT WRONG - however
  * we have userspace which relies on using these.
- * The wait interface is backwards compat new 
+ * The wait interface is backwards compat new
  * code should use the NEW_WAIT defines below
  * THESE ARE NOT BIT FIELDS
  */
-- 
1.7.10.4

