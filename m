Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2HOUhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:37:08 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62752 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab2HOTtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jonghwan Choi <jhbird.choi@samsung.com>,
        James Morris <james.l.morris@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 017/165] security: fix compile error in commoncap.c
Date: Wed, 15 Aug 2012 15:46:01 -0400
Message-ID: <1345060109-9187-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 51b79bee627d526199b2f6a6bef8ee0c0739b6d1 upstream.

Add missing "personality.h"
security/commoncap.c: In function 'cap_bprm_set_creds':
security/commoncap.c:510: error: 'PER_CLEAR_ON_SETID' undeclared (first use in this function)
security/commoncap.c:510: error: (Each undeclared identifier is reported only once
security/commoncap.c:510: error: for each function it appears in.)

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 security/commoncap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/commoncap.c b/security/commoncap.c
index 6166973..3927418 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -28,6 +28,7 @@
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 #include <linux/syslog.h>
+#include <linux/personality.h>
 
 /*
  * If a non-root user executes a setuid-root binary in
-- 
1.7.12.rc2

