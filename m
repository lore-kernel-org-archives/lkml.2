Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0KVSCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:02:17 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:4301 "EHLO mailfw02.zoner.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab0KVSCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:02:14 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Decompressors: Remove unused function from lib/decompress_unlzma.c
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
From: Lasse Collin <lasse.collin@tukaani.org>
Date: Mon, 22 Nov 2010 20:01:48 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011222001.48344.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

diff -uprN linux-2.6.37-rc3.orig/lib/decompress_unlzma.c linux-2.6.37-rc3/lib/decompress_unlzma.c
--- linux-2.6.37-rc3.orig/lib/decompress_unlzma.c	2010-10-20 23:30:22.000000000 +0300
+++ linux-2.6.37-rc3/lib/decompress_unlzma.c	2010-11-22 14:43:16.000000000 +0200
@@ -127,12 +127,6 @@ static inline void INIT rc_init_code(str
 }
 
 
-/* Called once. TODO: bb_maybe_free() */
-static inline void INIT rc_free(struct rc *rc)
-{
-	free(rc->buffer);
-}
-
 /* Called twice, but one callsite is in inline'd rc_is_bit_0_helper() */
 static void INIT rc_do_normalize(struct rc *rc)
 {
