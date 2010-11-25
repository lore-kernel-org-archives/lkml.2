Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0KYTbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 14:31:03 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:22302 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab0KYTbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 14:31:02 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Decompressors: Remove unused constant from inflate.h
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Thu, 25 Nov 2010 21:31:19 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011252131.19103.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

diff -uprN linux-2.6.37-rc3.orig/include/linux/decompress/inflate.h linux-2.6.37-rc3/include/linux/decompress/inflate.h
--- linux-2.6.37-rc3.orig/include/linux/decompress/inflate.h	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/include/linux/decompress/inflate.h	2010-11-25 19:52:10.000000000 +0200
@@ -1,9 +1,6 @@
 #ifndef INFLATE_H
 #define INFLATE_H
 
-/* Other housekeeping constants */
-#define INBUFSIZ 4096
-
 int gunzip(unsigned char *inbuf, int len,
 	   int(*fill)(void*, unsigned int),
 	   int(*flush)(void*, unsigned int),
