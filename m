Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0G2Kry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:47:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:60126 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828Ab0G2Krw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:47:52 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] Documentation: DMA-API-HOWTO.txt: add multiple types of IOMMUs support
Date: Thu, 29 Jul 2010 19:45:07 +0900
Message-Id: <1280400308-16114-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1280400308-16114-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1280400308-16114-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 19:47:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API-HOWTO.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 98ce517..3c4e071 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -753,6 +753,16 @@ to "Closing".
    alignment constraints (e.g. the alignment constraints about 64-bit
    objects).
 
+3) Supporting multiple types of IOMMUs
+
+   If your architecture needs to support multiple types of IOMMUs, you
+   can use include/linux/asm-generic/dma-mapping-common.h. It's a
+   library to support the DMA API with multiple types of IOMMUs. Lots
+   of architectures (x86, powerpc, sh, alpha, ia64, microblaze and
+   sparc) use it. Choose one to see how it can be used. If you need to
+   support multiple types of IOMMUs in a single system, the example of
+   x86 or powerpc helps.
+
 			   Closing
 
 This document, and the API itself, would not be in its current
-- 
1.6.5

