Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab2FTUKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:10:34 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:59515 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab2FTUKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:10:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/6] mn10300: kernel/internal.h needs <linux/irqreturn.h>
Date: Wed, 20 Jun 2012 22:09:47 +0200
Message-Id: <1340222990-20796-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
References: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from arch/mn10300/kernel/csrc-mn10300.c:14:0:
arch/mn10300/kernel/internal.h:42:1: error: unknown type name 'irqreturn_t'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/kernel/internal.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/kernel/internal.h b/arch/mn10300/kernel/internal.h
index a5ac755..2df4401 100644
--- a/arch/mn10300/kernel/internal.h
+++ b/arch/mn10300/kernel/internal.h
@@ -9,6 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/irqreturn.h>
+
 struct clocksource;
 struct clock_event_device;
 
-- 
1.7.0.4

