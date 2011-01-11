Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab1AKXgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:36:41 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55294 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1AKXgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:36:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HVIFnriaou1SsdK8SWTnvnAKJ2+Fxtjw4sjhoiYVnnxVotg4zT5ElCWUrxeT7LqObq
         veROGOOtZM+97UeOardCyuGK71b6cLDstJY891541uLAjfQFMcj8hHuincA5crmlBO5c
         Xr5nt5WZAkRjUt33nfr/WEsr/jPUjMKjW+p1c=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Alex Dubov <oakad@yahoo.com>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 4/4] memstick: add Alex Dubov to MAINTAINERS of the memstick core
Date: Wed, 12 Jan 2011 01:36:15 +0200
Message-Id: <1294788975-19584-5-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
References: <1294788975-19584-1-git-send-email-maximlevitsky@gmail.com>
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
index c9293f7..8687ba1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5614,7 +5614,18 @@ F:	drivers/char/sonypi.c
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

