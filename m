Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1FOWSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:18:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57941 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751958Ab1FOWSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:18:00 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/l6m8dODjlgrCIzqQPW0fcb0S4q3gV7r8g9nXAi3
	zwSiA0DIDLnei9
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH trivial] scripts/gcc-goto.sh: fix a typo ("suport")
Date: Thu, 16 Jun 2011 00:17:46 +0200
Message-Id: <1308176266-31827-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 scripts/gcc-goto.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
index 520d16b..98cffcb 100644
--- a/scripts/gcc-goto.sh
+++ b/scripts/gcc-goto.sh
@@ -1,5 +1,5 @@
 #!/bin/sh
-# Test for gcc 'asm goto' suport
+# Test for gcc 'asm goto' support
 # Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
 
 echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
-- 
1.7.5.4

