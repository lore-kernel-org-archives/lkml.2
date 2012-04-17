Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2DQXMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:12:39 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36598 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752120Ab2DQXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:12:38 -0400
Message-ID: <4F8DF90B.1090002@xenotime.net>
Date: Tue, 17 Apr 2012 16:13:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: qasdfgtyuiop <qasdfgtyuiop@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, alain@knaff.lu,
        albin.tonnerre@free-electrons.com, lasse.collin@tukaani.org,
        hpa@zytor.com
Subject: [PATCH] kconfig: update compression algorithm info
References: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com>
In-Reply-To: <CAMtaSwTi=7rmG8diJ+K0c_CcV=0TcgXDjRFEdZGGiKE2K5x89A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

There have been new compression algorithms added without
updating nearby relevant descriptive text that refers to
(a) the number of compression algorithms and (b) the most
recent one.  Fix these inconsistencies.

Reported-by: qasdfgtyuiop@gmail.com
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 init/Kconfig |   11 +++++------
 usr/Kconfig  |   10 +++++-----
 2 files changed, 10 insertions(+), 11 deletions(-)

--- lnx-34-rc3.orig/usr/Kconfig
+++ lnx-34-rc3/usr/Kconfig
@@ -134,7 +134,7 @@ config INITRAMFS_COMPRESSION_BZIP2
 	depends on RD_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the four.  The initramfs
+	  Decompression speed is slowest among the choices.  The initramfs
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -143,9 +143,9 @@ config INITRAMFS_COMPRESSION_LZMA
 	bool "LZMA"
 	depends on RD_LZMA
 	help
-	  The most recent compression algorithm.
-	  Its ratio is best, decompression speed is between the other
-	  three. Compression is slowest. The initramfs size is about 33%
+	  This algorithm's compression ratio is best.
+	  Decompression speed is between the other choices.
+	  Compression is slowest. The initramfs size is about 33%
 	  smaller with LZMA in comparison to gzip.
 
 config INITRAMFS_COMPRESSION_XZ
@@ -161,7 +161,7 @@ config INITRAMFS_COMPRESSION_LZO
 	bool "LZO"
 	depends on RD_LZO
 	help
-	  Its compression ratio is the poorest among the four. The kernel
+	  Its compression ratio is the poorest among the choices. The kernel
 	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
--- lnx-34-rc3.orig/init/Kconfig
+++ lnx-34-rc3/init/Kconfig
@@ -164,7 +164,7 @@ config KERNEL_BZIP2
 	depends on HAVE_KERNEL_BZIP2
 	help
 	  Its compression ratio and speed is intermediate.
-	  Decompression speed is slowest among the three.  The kernel
+	  Decompression speed is slowest among the choices.  The kernel
 	  size is about 10% smaller with bzip2, in comparison to gzip.
 	  Bzip2 uses a large amount of memory. For modern kernels you
 	  will need at least 8MB RAM or more for booting.
@@ -173,10 +173,9 @@ config KERNEL_LZMA
 	bool "LZMA"
 	depends on HAVE_KERNEL_LZMA
 	help
-	  The most recent compression algorithm.
-	  Its ratio is best, decompression speed is between the other
-	  two. Compression is slowest.	The kernel size is about 33%
-	  smaller with LZMA in comparison to gzip.
+	  This compression algorithm's ratio is best.  Decompression speed
+	  is between gzip and bzip2.  Compression is slowest.
+	  The kernel size is about 33% smaller with LZMA in comparison to gzip.
 
 config KERNEL_XZ
 	bool "XZ"
@@ -197,7 +196,7 @@ config KERNEL_LZO
 	bool "LZO"
 	depends on HAVE_KERNEL_LZO
 	help
-	  Its compression ratio is the poorest among the 4. The kernel
+	  Its compression ratio is the poorest among the choices. The kernel
 	  size is about 10% bigger than gzip; however its speed
 	  (both compression and decompression) is the fastest.
 
