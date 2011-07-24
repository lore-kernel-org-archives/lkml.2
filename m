Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1GXKHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 06:07:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45437 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1GXKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 06:07:11 -0400
MIME-Version: 1.0
Date: Sun, 24 Jul 2011 12:07:10 +0200
X-Google-Sender-Auth: iVfP8Bc9GHpSMy0p8j4XFE7QCKc
Message-ID: <CAPA4HGXsH4T9i1zbMhYDis5NBR7R_x0W=s8HHeNDXajnXDzCSA@mail.gmail.com>
Subject: [PATCH 1/2] Documentation/kernel-docs.txt: remove linux source
From: Luis de Bethencourt <luis@debethencourt.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping LSD (Linux Source Driver) since it hasn't been available
for a long time.

Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
---
 Documentation/kernel-docs.txt |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
index 9a86746..0e0734b 100644
--- a/Documentation/kernel-docs.txt
+++ b/Documentation/kernel-docs.txt
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
-- 
1.7.5.3
