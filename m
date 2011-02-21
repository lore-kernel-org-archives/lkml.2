Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1BUTW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:22:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39500 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab1BUTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:to:from:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=bZ03AAzomWurXujPU6RyxGKdBIxodhDH3dYQ8XAnzu7fxsBi03XAfL4HFQRQQpwnBH
         o8z3ANHmMNJh6NltEMCxCGeidOlphV29LQaaqvNyXtz3DJiGGKNCtHZ78Xtq49IRj9cr
         2UYxa9/Fl5X/ONQloZhZOtT3Pteyk1CvQwpVs=
Subject: [PATCH] crc32: add missed brackets in macro
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 21 Feb 2011 22:22:22 +0300
Message-ID: <20110221192222.6270.85389.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add brackets around typecasted argument in crc32() macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/crc32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index e20dd1f..391a259 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -11,7 +11,7 @@
 extern u32  crc32_le(u32 crc, unsigned char const *p, size_t len);
 extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
 
-#define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)data, length)
+#define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)(data), length)
 
 /*
  * Helpers for hash table generation of ethernet nics:

