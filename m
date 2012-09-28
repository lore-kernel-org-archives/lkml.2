Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030314Ab2I1XmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:42:00 -0400
Received: from nm2.bullet.mail.bf1.yahoo.com ([98.139.212.161]:22647 "HELO
	nm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965011Ab2I1XlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:41:06 -0400
X-Yahoo-Newman-Id: 934709.10138.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Qc12Kl4VM1laX1G0xApk2HoMJMYVq69Bstf8vJoaSLme_Sj
 t5iSv3jDJen8rAJlY4cArjzrPC.zZgLOOEPFNGZEPEk0LgTqDKYxHBBZ7n7M
 k.wOojJGZ0h_CmJiutXzr6sAANH6apFw9wRSlXyn4PBqOmI8WzJBlm.MnrJv
 64M7g8adu_eFO69VIljQ_3DW2eTsI2nQ_5HOuJ4YDD_b6ytKxQ66G.G_u38v
 KlT5sNF18oEQaNzEsEgPfiDym6UYDBfL9kvddVcFHGIiPA374uikpYuHejwC
 9VxVlZyicX9_dGu_SPCmN5vouwEN38RrlX.Fc2nLffBd84RuxOVcLGDDs_KD
 zRHArc9IvGXzUq1loPcjcAXOLbZBtbbxHonge5hU3m8EsQ2u2yfowwLLHqR7
 6o_Eo3EhM5L432c2EGWXnCrUeIweLqSGvtTydiQfAUVEs0kKsZLgE
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-doc@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v6 2/10] rbtree.h: include kconfig.h
Date: Fri, 28 Sep 2012 18:40:17 -0500
Message-Id: <1348875625-28669-3-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
References: <1348875625-28669-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't depend upon kernel.h including this for us.  However, this
also fixes some issues with compiling in userland (coming later).

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/rbtree.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 210ebeb..48e325f 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -33,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/bug.h>
+#include <linux/kconfig.h>
 
 struct rb_node {
 	unsigned long  __rb_parent_color;
-- 
1.7.3.4

