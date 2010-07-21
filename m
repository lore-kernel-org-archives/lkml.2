Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295Ab0GUGKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:10:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43499 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0GUGKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TCzAYbn9O36xADjVBVoZuQSO2fYyM8mHrDAe9/JwE9EQJbybYzSvbkW4qIoY/Ynt+G
         LIgQlkbhNNUK3qqpN+3vpBvJVAipoddkccSDoKPjU2TN98cxHcrEsfH61zYIbSHkhXLg
         rVZ3HcwVZ41CNYpbHwRVrZXCXbjfCIQGsUFqY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Thomas Weber <thomas.weber.linux@googlemail.com>
Subject: [PATCH 127/127 v2]Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt update web address.
Date: Tue, 20 Jul 2010 23:10:22 -0700
Message-Id: <1279692622-31584-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Thomas Weber <thomas.weber.linux@googlemail.com>

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

