Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1HMTfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:35:21 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:48042 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752025Ab1HMTfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:35:17 -0400
Date: Sat, 13 Aug 2011 12:34:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Luis de Bethencourt <luis@debethencourt.com>
Subject: [PATCH 2/8] Documentation: drop Linux Source Driver from
 kernel-docs references
Message-Id: <20110813123447.1cbd055b.rdunlap@xenotime.net>
In-Reply-To: <20110813122200.8e2fc879.rdunlap@xenotime.net>
References: <20110813122200.8e2fc879.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis de Bethencourt <luis@debethencourt.com>

Dropping LSD (Linux Source Driver) since it hasn't been available
for a long time.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/kernel-docs.txt |   11 -----------
 1 file changed, 11 deletions(-)

--- lnx-31-rc1-git7.orig/Documentation/kernel-docs.txt
+++ lnx-31-rc1-git7/Documentation/kernel-docs.txt
@@ -620,17 +620,6 @@
        (including this document itself) have been moved there, and might
        be more up to date than the web version.
 
-     * Name: "Linux Source Driver"
-       URL: http://lsd.linux.cz
-       Keywords: Browsing source code.
-       Description: "Linux Source Driver (LSD) is an application, which
-       can make browsing source codes of Linux kernel easier than you can
-       imagine. You can select between multiple versions of kernel (e.g.
-       0.01, 1.0.0, 2.0.33, 2.0.34pre13, 2.0.0, 2.1.101 etc.). With LSD
-       you can search Linux kernel (fulltext, macros, types, functions
-       and variables) and LSD can generate patches for you on the fly
-       (files, directories or kernel)".
-
      * Name: "Linux Kernel Source Reference"
        Author: Thomas Graichen.
        URL: http://marc.info/?l=linux-kernel&m=96446640102205&w=4
