Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1AROIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 09:08:22 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40321 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1AROIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:08:19 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 3/3] keys: add trusted and encrypted maintainers
Date: Tue, 18 Jan 2011 09:07:13 -0500
Message-Id: <1295359633-4993-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1295359633-4993-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself and David Safford as maintainers for trusted/encrypted keys.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 MAINTAINERS |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3dd5c6f..4c3191b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3670,6 +3670,28 @@ F:	include/linux/key-type.h
 F:	include/keys/
 F:	security/keys/
 
+KEYS-TRUSTED
+M:	David Safford <safford@watson.ibm.com>
+M:	Mimi Zohar <zohar@us.ibm.com>
+L:	linux-security-module@vger.kernel.org
+L:	keyrings@linux-nfs.org
+S:	Supported
+F:	Documentation/keys-trusted-encrypted.txt
+F:	include/keys/trusted-type.h
+F:	security/keys/trusted.c
+F:	security/keys/trusted.h
+
+KEYS-ENCRYPTED
+M:	Mimi Zohar <zohar@us.ibm.com>
+M:	David Safford <safford@watson.ibm.com>
+L:	linux-security-module@vger.kernel.org
+L:	keyrings@linux-nfs.org
+S:	Supported
+F:	Documentation/keys-trusted-encrypted.txt
+F:	include/keys/encrypted-type.h
+F:	security/keys/encrypted.c
+F:	security/keys/encrypted.h
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 W:	http://kgdb.wiki.kernel.org/
-- 
1.7.3.4

