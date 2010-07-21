Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500Ab0GUFMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:12:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41254 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762187Ab0GUEzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:55:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SrcgnmthjVszMUbG/jc0JZJ1bWM0NvCGZU6s0ITFqZgfMQgHwtCmVy+c8/9HDs/f6/
         mG3IM5ds6GFwqTwwvmhEgY9zifL0PViyyokKYvEmbyOD6eM0DArtPYLVJtMyAD3YvF+8
         ax0YSruHB4G7B3Dl5Hilt7yRxUkw/l2CgvvI4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 71/71]Documentation/misc-devices/c2port.txt update web address.
Date: Tue, 20 Jul 2010 21:54:52 -0700
Message-Id: <1279688096-29519-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
References: <1279688096-29519-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web addresses to the best of
my knowledge.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/misc-devices/c2port.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/misc-devices/c2port.txt b/Documentation/misc-devices/c2port.txt
index d9bf93e..75f3e1f 100644
--- a/Documentation/misc-devices/c2port.txt
+++ b/Documentation/misc-devices/c2port.txt
@@ -32,10 +32,10 @@ The C2 Interface main references are at (http://www.silabs.com)
 Silicon Laboratories site], see:
 
 - AN127: FLASH Programming via the C2 Interface at
-http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf, and
+http://www.silabs.com/Support Documents/TechnicalDocs/an127.pdf 
 
 - C2 Specification at
-http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf,
+http://www.silabs.com/
 
 however it implements a two wire serial communication protocol (bit
 banging) designed to enable in-system programming, debugging, and
-- 
1.7.1.rc1.21.gf3bd6

