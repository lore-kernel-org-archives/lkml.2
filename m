Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0HRVO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:14:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54099 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab0HRVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eQkR+HG5dGB5ApzPPYuIiN1s6PNiaER2Mge+Cok/x9RtmenKIGL4a178qLr1XQlQw0
         7wMZD0h+8YWZ9m7eyRblH9jMGUt1Sw7Kkj8DK7AFYV7f/oCEfOnCZKeuYcnj7FJbbYws
         08NoNjyQsctII+c0TufF0GKKbW5VUc4aA6WFg=
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH] scripts/mkversion: Simplify script
Date: Thu, 19 Aug 2010 02:42:25 +0530
Message-Id: <1282165945-27195-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the script and add a line to help editors recognize this as a
shell script.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
---
 scripts/mkversion |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/scripts/mkversion b/scripts/mkversion
index c12addc..6fedcb3 100644
--- a/scripts/mkversion
+++ b/scripts/mkversion
@@ -1,6 +1,3 @@
-if [ ! -f .version ]
-then
-    echo 1
-else
-    expr 0`cat .version` + 1
-fi
+#!/bin/sh
+
+[ ! -f .version ] && echo 1 || expr 0`cat .version` + 1
-- 
1.7.1

