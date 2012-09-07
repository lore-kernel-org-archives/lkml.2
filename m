Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab2IGUlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:41:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35524 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab2IGUlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:41:23 -0400
From: Jon Stanley <jonstanley@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jon Stanley <jonstanley@gmail.com>
Subject: [PATCH 2/2] Add copyright header.
Date: Fri,  7 Sep 2012 16:32:47 -0400
Message-Id: <1347049967-3143-2-git-send-email-jonstanley@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
References: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a missing copyright header to parse-utils.c
---
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

