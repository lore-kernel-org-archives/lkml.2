Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab0ELIuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:50:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:54488 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab0ELItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:49:41 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       tytso@mit.edu, iws@ovro.caltech.edu
Cc: stefani@seibold.net
Subject: [PATCH 3/4] replace the old non generic API
Date: Wed, 12 May 2010 10:49:26 +0200
Message-Id: <1273654167-31067-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273654167-31067-1-git-send-email-stefani@seibold.net>
References: <1273654167-31067-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch simple replace the whole kfifo.c and kfifo.h files by the new
generic version and fix the kerneldoc API template file.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 Documentation/DocBook/kernel-api.tmpl  |    1 -
 include/linux/{kfifo-new.h => kfifo.h} |    0
 kernel/{kfifo-new.c => kfifo.c}        |    0
 3 files changed, 0 insertions(+), 1 deletions(-)
 rename include/linux/{kfifo-new.h => kfifo.h} (100%)
 rename kernel/{kfifo-new.c => kfifo.c} (100%)

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index 44b3def..a20c6f6 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -132,7 +132,6 @@ X!Ilib/string.c
      <title>FIFO Buffer</title>
      <sect1><title>kfifo interface</title>
 !Iinclude/linux/kfifo.h
-!Ekernel/kfifo.c
      </sect1>
   </chapter>
 
diff --git a/include/linux/kfifo-new.h b/include/linux/kfifo.h
similarity index 100%
rename from include/linux/kfifo-new.h
rename to include/linux/kfifo.h
diff --git a/kernel/kfifo-new.c b/kernel/kfifo.c
similarity index 100%
rename from kernel/kfifo-new.c
rename to kernel/kfifo.c
-- 
1.7.0.4

