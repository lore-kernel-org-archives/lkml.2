Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2IHSBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:01:21 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:59622 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2IHSBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:01:19 -0400
X-Greylist: delayed 77163 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2012 14:01:19 EDT
From: Jon Stanley <jonstanley@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jon Stanley <jonstanley@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2 v2] Add copyright header.
Date: Sat,  8 Sep 2012 14:00:51 -0400
Message-Id: <1347127251-4695-1-git-send-email-jonstanley@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
References: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a missing copyright header to parse-utils.c. Assuminng that the
license is LGPL like the rest of the trace-cmd library code.

Signed-off-by: Jon Stanley <jonstanley@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
* Changes for v2 -

I seem to have forgotten to add the Signed-off-by abnd CC lines. Now included.

 tools/lib/traceevent/parse-utils.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/parse-utils.c b/tools/lib/traceevent/parse-utils.c
index f023a13..bba701c 100644
--- a/tools/lib/traceevent/parse-utils.c
+++ b/tools/lib/traceevent/parse-utils.c
@@ -1,3 +1,22 @@
+/*
+ * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-- 
1.7.1

