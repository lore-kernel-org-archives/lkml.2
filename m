Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1LIEXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:23:32 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41526 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753653Ab1LIEX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:23:29 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v3.2 10/10] MAINTAINERS: Update encrypted-keys F: patterns
Date: Thu,  8 Dec 2011 20:21:48 -0800
Message-Id: <f60772da9967041d81ed084947bd79ee3f975596.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 61cf45d0199 ("encrypted-keys: create encrypted-keys directory")
moved the files, update the patterns.

CC: Mimi Zohar <zohar@us.ibm.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 69c5720..2173f6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3873,8 +3873,7 @@ L:	keyrings@linux-nfs.org
 S:	Supported
 F:	Documentation/security/keys-trusted-encrypted.txt
 F:	include/keys/encrypted-type.h
-F:	security/keys/encrypted.c
-F:	security/keys/encrypted.h
+F:	security/keys/encrypted-keys/
 
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
-- 
1.7.8.111.gad25c.dirty

