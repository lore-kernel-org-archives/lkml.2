Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0LMVma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:42:30 -0500
Received: from mail.perches.com ([173.55.12.10]:2575 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab0LMVm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:42:29 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 3/5] serial: samsung: Use vsprintf extension %pR for struct resource
Date: Mon, 13 Dec 2010 13:42:20 -0800
Message-Id: <a29599083789a50fe836abbd57c972301c1e579f.1292276119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292276119.git.joe@perches.com>
References: <cover.1292276119.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
index 7ac2bf5..f71f511 100644
--- a/drivers/serial/samsung.c
+++ b/drivers/serial/samsung.c
@@ -1098,7 +1098,7 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 		return -EINVAL;
 	}
 
-	dbg("resource %p (%lx..%lx)\n", res, res->start, res->end);
+	dbg("resource %pR\n", res);
 
 	port->mapbase = res->start;
 	port->membase = S3C_VA_UART + (res->start & 0xfffff);
-- 
1.7.3.3.398.g0b0cd.dirty

