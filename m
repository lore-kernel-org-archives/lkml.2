Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab2HGAHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 20:07:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61546 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab2HGAHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 20:07:13 -0400
MIME-Version: 1.0
Date: Tue, 7 Aug 2012 00:07:11 +0000
Message-ID: <CAGh4K3+krr7Zy97VeFm80U3xsidaWwHLWcbKb-WZ4x+3vH4Sug@mail.gmail.com>
Subject: [PATCH]: BeFs parser.h support in linux kernel v3.5
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new header, in the to-do list. There are no style issues.
Here's the patch:
--
Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
--- befs.h      2012-07-21 20:58:29.000000000 +0000
+++ befs.h      2012-08-06 19:52:05.000000000 +0000
@@ -9,6 +9,7 @@
 #define _LINUX_BEFS_H

 #include "befs_fs_types.h"
+#include "linux-3.5/include/parser.h"

 /* used in debug.c */
 #define BEFS_VERSION "0.9.3"

--

-- 
Christopher
