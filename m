Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2IYXhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:37:35 -0400
Received: from nm2.bullet.mail.ac4.yahoo.com ([98.139.52.199]:25643 "HELO
	nm2.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755216Ab2IYXhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:37:32 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2012 19:37:32 EDT
X-Yahoo-Newman-Id: 526411.74705.bm@omp1028.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _YM5FMoVM1kf42LFdtSE7LlRQH2o2QDTkpaW2DYx412uti2
 tR7LluHIK2fP8pJvJXO2Z1VqAbLb0nhLzTgxUybvMjjv734e20pWXHgoeefA
 Ien.RBTwIWvS509JslFJ4LG.fAfOkFvrC_W.k72dGPHs5.3ETxCsnaaQI2z0
 gOgQUFgYDlG3eC3YPSCgBbBFXWV8TjpsNHtZalOAWRZNq.yRsOPEcsU3lJwm
 tR2l7auwI3Ch.e.yUWqoubBErULGqX4duzmWAzCjKkE9kREB9VqfcGT4thew
 aeiby4YIUJAGaxYwXk.hrij3yIL1pRr9H87.ERFj7vKXWNN2mZ1RJwJr4dk8
 Ni7K.w1iVAOsgCFJtwsLSxldKnKQv_3PzIHHilf6Sjs7SLKH_7z3h7kYx5mD
 GhZws5shAwnsrB4bsA537WqpJdy_M8PR9pe20PRj5N8eDvmx6zr7a
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 6/25] bug.h: Replace __linktime_error with __compiletime_error
Date: Tue, 25 Sep 2012 18:30:38 -0500
Message-Id: <1348615838-10160-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index aaac4bb..298a916 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
 #define BUILD_BUG()						\
 	do {							\
 		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
+			__compiletime_error("BUILD_BUG failed");\
 		__build_bug_failed();				\
 	} while (0)
 
-- 
1.7.3.4

