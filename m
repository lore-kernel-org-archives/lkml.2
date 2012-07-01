Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2GANo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 09:44:57 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4710 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932331Ab2GANo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 09:44:56 -0400
Message-ID: <1341150294.1911.119.camel@x61.thuisdomein>
Subject: [PATCH 4/6] [TRIVIAL] kconfig: remove lkc_defs.h from .gitignore
 and dontdiff
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 01 Jul 2012 15:44:54 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Jul 2012 13:44:55.0154 (UTC) FILETIME=[B2932520:01CD578F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5a6f8d2bd9e3392569ed6f29ea4d7210652f929b ("kconfig: nuke
LKC_DIRECT_LINK cruft") removed all traces of lkc_defs.h from the tree.
Remove its entries in dontdiff and kconfig's .gitignore file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep only.

 Documentation/dontdiff     |    1 -
 scripts/kconfig/.gitignore |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index c48e21d..381f3f9 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -150,7 +150,6 @@ keywords.c
 ksym.c*
 ksym.h*
 kxgettext
-lkc_defs.h
 lex.c
 lex.*.c
 linux
diff --git a/scripts/kconfig/.gitignore b/scripts/kconfig/.gitignore
index ee120d4..be603c4 100644
--- a/scripts/kconfig/.gitignore
+++ b/scripts/kconfig/.gitignore
@@ -7,7 +7,6 @@ config*
 *.tab.h
 zconf.hash.c
 *.moc
-lkc_defs.h
 gconf.glade.h
 *.pot
 *.mo
-- 
1.7.7.6

