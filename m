Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0J3VQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:16:33 -0400
Received: from mail.perches.com ([173.55.12.10]:3722 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0J3VJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:27 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/39] drivers/acpi: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:23 -0700
Message-Id: <5188d583646249745c87ec1e3a1850d5b9748529.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
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
1.7.3.1.g432b3.dirty

