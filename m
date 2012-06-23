Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2FWEHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:07:33 -0400
Received: from nm26-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.225]:47815
	"HELO nm26-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751655Ab2FWEHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:07:31 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2012 00:07:31 EDT
X-Yahoo-Newman-Id: 460722.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TcBCs14VM1kTjs3eV2ZN9mjn8gg592WoqBlrA1jsqF0PAYg
 T_5aBPXdIPMYaEpTjXOp0NMrlY8x0lkcrdxw5i_dvcCyqAIhWDr2WnIJv8kv
 QJTsxNUIkejffoJHMXOvFAyChBrNHgVbJV8vqHF2wvNxQjzApmyNpAvgsin5
 tJ17Zos9xF0Tg94wJBHX8TCzL.K3zZNMphD6cjY6FbIAE3NHlqTnZJRp8bg5
 NoqIaK7O8ctXq6tkctPXSbF1QZnuJnhb9XeVuYU4A27YES0foR1uCTlclShL
 LlDdhmab4BkEYBko9zyTpkurTH7380_3lvxGqg9NFbUlLpn5HfhoQkCzpbOs
 wdFTRqnYfVi8bNoY7i6qstKR6J3DQKa5yqmmL.ycH0pIQ2mb4i7UWctVTo2K
 uNesXV9BA8xKZVqAQbtH0xvr6E3JwL8xYTQ--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Turner <pjt@google.com>, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v4 6/13] bug.h: Replace __linktime_error with __compiletime_error
Date: Fri, 22 Jun 2012 23:00:41 -0500
Message-Id: <1340424048-7759-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
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

