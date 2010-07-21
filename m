Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab0GUFAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:00:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64318 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab0GUE7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=boPGJXTY9vsz8w0hPLcIo5eCFbEilgNejF2j4+1PzURrZ/6JdXwFYcDcsMizflMSM2
         5yHFwgQkNCj0vWiDT7P86p7iO7TjxUEOzzmGwtn7AW2CwkN3FHynjxF5LLXc6y70Mkeg
         R9/38emEOIQARPCetJkKHbvgu3pi5j+MI/rIg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 127/127]Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt update web address.
Date: Tue, 20 Jul 2010 21:58:44 -0700
Message-Id: <1279688336-29735-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
References: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unused web address due to me
having no idea of it's location. if you know let me know.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 .../video4linux/cx88/hauppauge-wintv-cx88-ir.txt   |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt b/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
index faccee6..0958907 100644
--- a/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
+++ b/Documentation/video4linux/cx88/hauppauge-wintv-cx88-ir.txt
@@ -44,8 +44,6 @@ http://www.atmel.com/dyn/resources/prod_documents/doc2817.pdf
 This data sheet (google search) seems to have a lovely description of the
 RC5 basics
 
-http://users.pandora.be/nenya/electronics/rc5/  and more data
-
 http://www.ee.washington.edu/circuit_archive/text/ir_decode.txt
 and even a reference to how to decode a bi-phase data stream.
 
-- 
1.7.1.rc1.21.gf3bd6

