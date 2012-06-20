Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2FTUKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:10:09 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:40218 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab2FTUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:10:02 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/6] mn10300: kernel/traps.c needs <linux/export.h>
Date: Wed, 20 Jun 2012 22:09:48 +0200
Message-Id: <1340222990-20796-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
References: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/mn10300/kernel/traps.c:304:1: warning: data definition has no type or storage class [enabled by default]
arch/mn10300/kernel/traps.c:304:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/mn10300/kernel/traps.c:304:1: warning: parameter names (without types) in function declaration [enabled by default]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/kernel/traps.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 94a9c6d..b900e5a 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/kdebug.h>
 #include <linux/bug.h>
 #include <linux/irq.h>
+#include <linux/export.h>
 #include <asm/processor.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
-- 
1.7.0.4

