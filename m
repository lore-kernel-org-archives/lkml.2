Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0GJIjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 04:39:33 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48444 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751373Ab0GJIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 04:39:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: christ.li@gmail.com
Cc: jirislaby@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 2/2] parser: define __builtin_unreachable
Date: Sat, 10 Jul 2010 10:39:22 +0200
Message-Id: <1278751162-10053-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
References: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc 4.5 defines
extern void __builtin_unreachable(void);
so, add it also to sparse.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib.c b/lib.c
index a218bfc..ae6a20c 100644
--- a/lib.c
+++ b/lib.c
@@ -740,6 +740,7 @@ void declare_builtin_functions(void)
 	add_pre_buffer ("extern char * __builtin___strncpy_chk(char *, const char *, __SIZE_TYPE__, __SIZE_TYPE__);\n");
 	add_pre_buffer ("extern int __builtin___vsprintf_chk(char *, int, __SIZE_TYPE__, const char *, __builtin_va_list);\n");
 	add_pre_buffer ("extern int __builtin___vsnprintf_chk(char *, __SIZE_TYPE__, int, __SIZE_TYPE__, const char *, __builtin_va_list ap);\n");
+	add_pre_buffer ("extern void __builtin_unreachable(void);\n");
 }
 
 void create_builtin_stream(void)
-- 
1.7.1


