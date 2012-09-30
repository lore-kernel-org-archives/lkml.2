Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab2I3LpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:45:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59921 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2I3Loo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:44:44 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 2/2] simple_strto*: annotate function as obsolete
Date: Sun, 30 Sep 2012 13:44:29 +0200
Message-Id: <1349005469-19918-2-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349005469-19918-1-git-send-email-eldad@fogrefinery.com>
References: <1349005469-19918-1-git-send-email-eldad@fogrefinery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update the documentation to simple_strto* to reflect
that it has been obsoleted and advise the usage of kstrto*.

Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 lib/vsprintf.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0e33754..86e27d7 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -38,6 +38,8 @@
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoull instead.
  */
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
@@ -61,6 +63,8 @@ EXPORT_SYMBOL(simple_strtoull);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoul instead.
  */
 unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
 {
@@ -73,6 +77,8 @@ EXPORT_SYMBOL(simple_strtoul);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtol instead.
  */
 long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
@@ -88,6 +94,8 @@ EXPORT_SYMBOL(simple_strtol);
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed here
  * @base: The number base to use
+ *
+ * This function is obsolete. Please use kstrtoll instead.
  */
 long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 {
-- 
1.7.8.6

