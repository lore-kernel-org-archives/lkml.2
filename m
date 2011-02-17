Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1BQDBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:01:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34098 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1BQC7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WQioams+Dm4A57lS1VpdVeM0Eib/kVieOd4QydhcsJoamrQ4JWVNp5TgYdxcdr2qeN
         sSfoWF3bBfvkNkwVb5HaLPhAztXc/IeVm5BcgmYj2inVzcIwRdhopyGLbiL9MBIaKnGU
         Olm4JRWGW37JSRH6zR6W3cbXCY2zgxepz7HdM=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 02/10] Staging: tidspbridge: fixed an include issue changing asm/atomic.h to linux/atomic.h
Date: Thu, 17 Feb 2011 03:58:46 +0100
Message-Id: <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index 6549898..1e32a7f 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -18,7 +18,7 @@
 #define _HOST_OS_H_
 
 #include <asm/system.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
 #include <linux/irq.h>
-- 
1.7.1

