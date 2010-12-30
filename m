Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0L3EDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 23:03:43 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0L3EDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 23:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JHHHreMc3GkiuL0RhhlX7Sul0byPK/K6929j1SNokMvYIn4dt5hoAQcclZf+akIaet
         kHzh+jJRDzZV5H+OfRnA==
Date: Wed, 29 Dec 2010 20:02:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 8/8] usr: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1012292002040.27241@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EMBEDDED has been renamed to CONFIG_EXPERT, so fix it in the usr/
directory.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 usr/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/usr/Kconfig b/usr/Kconfig
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -46,7 +46,7 @@ config INITRAMFS_ROOT_GID
 	  If you are not sure, leave it set to "0".
 
 config RD_GZIP
-	bool "Support initial ramdisks compressed using gzip" if EMBEDDED
+	bool "Support initial ramdisks compressed using gzip" if EXPERT
 	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_GZIP
@@ -55,8 +55,8 @@ config RD_GZIP
 	  If unsure, say Y.
 
 config RD_BZIP2
-	bool "Support initial ramdisks compressed using bzip2" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using bzip2" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
 	help
@@ -64,8 +64,8 @@ config RD_BZIP2
 	  If unsure, say N.
 
 config RD_LZMA
-	bool "Support initial ramdisks compressed using LZMA" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using LZMA" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
 	help
@@ -73,8 +73,8 @@ config RD_LZMA
 	  If unsure, say N.
 
 config RD_LZO
-	bool "Support initial ramdisks compressed using LZO" if EMBEDDED
-	default !EMBEDDED
+	bool "Support initial ramdisks compressed using LZO" if EXPERT
+	default !EXPERT
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
 	help
