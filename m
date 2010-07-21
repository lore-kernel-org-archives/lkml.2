Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab0GUHOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:14:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50347 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399Ab0GUHOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sUqBvYfmj9WnhXCnFO0c0t1y+abje/sYXVd/+mSJCXUVcyEoCJpB25umGndvJy550C
         0PEgwK+/0m+mL1ff9UFrCkyY5UHv8thLNtpRRppNoQpepCjv0oixZd/C1iV3d7n4+Pbk
         9rMvLr4Bc3q6kEjfNnS++bCKbFZ2IaAWT3FZs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Thomas Weber <weber@corscience.de>
Subject: [PATCH 127/127 v3]Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt update web address.
Date: Wed, 21 Jul 2010 00:14:18 -0700
Message-Id: <1279696458-1115-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Thomas Weber <weber@corscience.de>

---
 .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt b/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
index faccee6..a2fd363 100644
--- a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
+++ b/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
@@ -44,7 +44,7 @@ http://www.atmel.com/dyn/resources/prod_documents/doc2817.pdf
 This data sheet (google search) seems to have a lovely description of the
 RC5 basics
 
-http://users.pandora.be/nenya/electronics/rc5/  and more data
+http://www.nenya.be/beor/electronics/rc5.htm and more data
 
 http://www.ee.washington.edu/circuit_archive/text/ir_decode.txt
 and even a reference to how to decode a bi-phase data stream.
-- 
1.7.1.rc1.21.gf3bd6

