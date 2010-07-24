Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0GXKl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:41:27 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38555 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0GXKl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:41:26 -0400
Date: Sat, 24 Jul 2010 06:41:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: ceph-devel@vger.kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] CEPH: Correct obvious typo of Kconfig variable
 "CRYPTO_AES"
Message-ID: <alpine.DEB.2.00.1007240639590.10227@lynx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 04b8280..bc87b9c 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -2,7 +2,7 @@ config CEPH_FS
         tristate "Ceph distributed file system (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
 	select LIBCRC32C
-	select CONFIG_CRYPTO_AES
+	select CRYPTO_AES
 	help
 	  Choose Y or M here to include support for mounting the
 	  experimental Ceph distributed file system.  Ceph is an extremely

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
