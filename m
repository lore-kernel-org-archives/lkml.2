Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0DSVxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:53:24 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:55067 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0DSVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:53:22 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 1/5] uml: Remove unused variable from line driver
Date: Mon, 19 Apr 2010 23:53:04 +0200
Message-Id: <f430193946dbd11791e8fb5bef2e4a8e68393828.1271713955.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX18WdcA4XPT0gUrR3L/XTUw8oaW8vv1sHN8M11Ay
	x2FT7bHY8iNzBYKDtCXHvAR+0qIXCK9MMysflaEDP00tjvw1Bx
	RD2djUvwA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 arch/um/drivers/line.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 7a656bd..7f7338c 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -19,7 +19,6 @@ static irqreturn_t line_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty;
 
 	if (line)
 		chan_interrupt(&line->chan_list, &line->task, line->tty, irq);
-- 
1.6.0.2

