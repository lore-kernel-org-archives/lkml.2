Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab1CDERX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:17:23 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39231 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab1CDERR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:17:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SAjdaYJSf4yiQQEbaFmJZfiszOkHJ2kZYb5DSnqgf+FfIKjP1qW+x6MPD4Ml1PMxaQ
         Dm4IjkxYSjmOw9ix7bEH+RzfERgZ1gMByGyrCFpr3uwFBAXua4lElrD4y7svyWjJaNHo
         1H5CFw64T31W582ZIn2aOhQ5ngPKLRQC5venM=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 4/4] memstick: add Alex Dubov to MAINTAINERS of the memstick core
Date: Fri,  4 Mar 2011 06:16:53 +0200
Message-Id: <1299212213-4255-5-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is supposed to be maintained by him and unless
he doesn't want to do so, MAINTAINERS should reflect
the state of things, and bugreporters should know
whom to blame for bugs.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 MAINTAINERS |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 08dfc7e..75ae9a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5798,7 +5798,18 @@ F:	drivers/char/sonypi.c
 F:	drivers/platform/x86/sony-laptop.c
 F:	include/linux/sony-laptop.h
 
-SONY MEMORYSTICK CARD SUPPORT
+SONY MEMORYSTICK SUBSYSTEM
+M:	Alex Dubov <oakad@yahoo.com>
+S:	Maintained
+F:	drivers/memstick/memstick.c
+F:	drivers/memstick/mspro_block.c
+
+SONY MEMORYSTICK DRIVER FOR JMICRON CONTROLLERS
+M:	Alex Dubov <oakad@yahoo.com>
+S:	Maintained
+F:	drivers/memstick/host/jmb38x_ms.c
+
+SONY MEMORYSTICK DRIVER FOR TI CONTROLLERS
 M:	Alex Dubov <oakad@yahoo.com>
 W:	http://tifmxx.berlios.de/
 S:	Maintained
-- 
1.7.1

