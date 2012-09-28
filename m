Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053Ab2I1XVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:21:11 -0400
Received: from nm40-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.183]:31453 "HELO
	nm40-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758808Ab2I1XVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:21:04 -0400
X-Yahoo-Newman-Id: 877895.59262.bm@omp1025.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: n69SUEAVM1mejJTEG5kOO7jo6dnJ6BMYjT7pwyw2qqdebls
 fnFILcjqX2.cjcNasoXFIq8AU50wCsoiwFiofIkZwx7hNz_Ti0t8FsUGd_Xp
 pBUvL8z0cIA19bCWN_wgfgHvVo4_EgDAHhR1FUvkNa2zkKhlhjtZfitwBgQc
 1TYXm1CaZf.NmcUuvca2jBJMa_hCs6hfB8CvvpFv.Oy2adVZfzZqBon4UESu
 zNjUXCzNdeafCKgeQ8.7AXYpMb37adXlvlMroNU6yEEGxUWjvXR6Au1CXHc_
 Rn6M_2fnX2G4.o2wFvo0I8JdRiTIrWOw32drkUruomsM3A0QsuhXNLDj3L2L
 6VXchlyI7iQpNxdgDZKZRfCkqXhXLMR0natD3NRefDw2atBttuKWwglaAn2s
 _gox6_N._9aPAoevapb27jq9M0.ovBGXhmvnUZW1SHfGoqZD0DL9C0Q--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/10] bug.h: Replace __linktime_error with __compiletime_error
Date: Fri, 28 Sep 2012 18:20:07 -0500
Message-Id: <1348874411-28288-7-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
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

