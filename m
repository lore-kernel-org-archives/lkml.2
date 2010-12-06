Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0LFWKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:10:41 -0500
Received: from mail.perches.com ([173.55.12.10]:2333 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0LFWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/29] drivers/acpi: Update WARN uses
Date: Mon,  6 Dec 2010 14:04:56 -0800
Message-Id: <9a2820443f2ad22d28e7f8cd036958dcefe80438.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/acpi/ec.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 372ff80..d41d68e 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -818,9 +818,9 @@ static int acpi_ec_add(struct acpi_device *device)
 	device->driver_data = ec;
 
 	WARN(!request_region(ec->data_addr, 1, "EC data"),
-	     "Could not request EC data io port 0x%lx", ec->data_addr);
+	     "Could not request EC data io port 0x%lx\n", ec->data_addr);
 	WARN(!request_region(ec->command_addr, 1, "EC cmd"),
-	     "Could not request EC cmd io port 0x%lx", ec->command_addr);
+	     "Could not request EC cmd io port 0x%lx\n", ec->command_addr);
 
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
-- 
1.7.3.2.245.g03276.dirty

