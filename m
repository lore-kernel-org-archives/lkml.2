Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab0L3EDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 23:03:00 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9753 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0L3ECt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 23:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=bhVrLDH39ht26B3Fgrl744Ska0Z3DQi79Q7aR/HQEziZh7ViJxRtDTnP/Fd9/eFVAY
         vwmneypu2mDTSdrUs6Gw==
Date: Wed, 29 Dec 2010 20:02:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/8] fs: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1012292000460.27241@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EMBEDDED has been renamed to CONFIG_EXPERT, so fix it in the fs/
directory.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/Kconfig       |    2 +-
 fs/proc/Kconfig  |    6 +++---
 fs/sysfs/Kconfig |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -51,7 +51,7 @@ config EXPORTFS
 	tristate
 
 config FILE_LOCKING
-	bool "Enable POSIX file locking API" if EMBEDDED
+	bool "Enable POSIX file locking API" if EXPERT
 	default y
 	help
 	  This option enables standard file locking support, required
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -1,5 +1,5 @@
 config PROC_FS
-	bool "/proc file system support" if EMBEDDED
+	bool "/proc file system support" if EXPERT
 	default y
 	help
 	  This is a virtual file system providing information about the status
@@ -40,7 +40,7 @@ config PROC_VMCORE
         Exports the dump image of crashed kernel in ELF format.
 
 config PROC_SYSCTL
-	bool "Sysctl support (/proc/sys)" if EMBEDDED
+	bool "Sysctl support (/proc/sys)" if EXPERT
 	depends on PROC_FS
 	select SYSCTL
 	default y
@@ -61,7 +61,7 @@ config PROC_SYSCTL
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
-	bool "Enable /proc page monitoring" if EMBEDDED
+	bool "Enable /proc page monitoring" if EXPERT
  	help
 	  Various /proc files exist to monitor process memory utilization:
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
diff --git a/fs/sysfs/Kconfig b/fs/sysfs/Kconfig
--- a/fs/sysfs/Kconfig
+++ b/fs/sysfs/Kconfig
@@ -1,5 +1,5 @@
 config SYSFS
-	bool "sysfs file system support" if EMBEDDED
+	bool "sysfs file system support" if EXPERT
 	default y
 	help
 	The sysfs filesystem is a virtual filesystem that the kernel uses to
