Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2FWEHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 00:07:40 -0400
Received: from nm17-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.21]:37099
	"HELO nm17-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752693Ab2FWEHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 00:07:36 -0400
X-Yahoo-Newman-Id: 843846.55476.bm@smtp103.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jvsaaccVM1mfDaxj89Wf5pgbOsXGMp_4HZ4Gp2hiIV24oH_
 qxvmxc1Yol1GOt3SxqaNCC3T2GofwDHMpuYZUTbtdkojjfenZlQn4wjBNn5O
 iI3lt7P2K43cBGze_dYlrjuZlpKNSkHnYgAy79JaracsD4.oxb9JO8Hg2rRU
 HFjdxTi24WpImE0wmprH5mfIwNUmYtGgBBq89LkgP7eZjnxa0soBY7v2LSZm
 exlF0QReQCTt7_UaLpZBTmpD7VhqMT73SH1uQxvPLJq0QZnxlb4Bvt81EokY
 95e.23jHNQphgo3CfWMNf0v9YVcXicL6ZahqMKQmzdqzgaRCKBxfqX5fhoaq
 T1Y4OlkX6b4tzqUoyuaAjAC2r9wbjmkyrEiKPP.POvUz9_HwWE2mDv__b1_U
 bMbY7lDq2HNTQjP8YYA.6lsWsMqot8JUYhNw-
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
Subject: [PATCH v4 13/13] documentation for rbtrees
Date: Fri, 22 Jun 2012 23:00:48 -0500
Message-Id: <1340424048-7759-14-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 Documentation/DocBook/kernel-api.tmpl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
index 00687ee..210e9aa 100644
--- a/Documentation/DocBook/kernel-api.tmpl
+++ b/Documentation/DocBook/kernel-api.tmpl
@@ -43,6 +43,10 @@
      <sect1><title>Doubly Linked Lists</title>
 !Iinclude/linux/list.h
      </sect1>
+     <sect1><title>Red-Black Trees</title>
+!Iinclude/linux/rbtree.h
+!Ilib/rbtree.c
+     </sect1>
   </chapter>
 
   <chapter id="libc">
-- 
1.7.3.4

