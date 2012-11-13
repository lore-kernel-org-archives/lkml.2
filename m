Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2KMEjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 23:39:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2KMEjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 23:39:35 -0500
From: Andrew Cooks <acooks@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andrew Cooks <acooks@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com> (supporter:PCI SUBSYSTEM),
        linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Add missing license for ioapic module.
Date: Tue, 13 Nov 2012 12:39:07 +0800
Message-Id: <1352781547-9433-1-git-send-email-acooks@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

config PCI_IOAPIC turned into a tristate in commit b95a7bd700466c10fda84acbd33f70cf66ec91ce, but no module license is specified. This adds the missing module license.

Signed-off-by: Andrew Cooks <acooks@gmail.com>
---
 drivers/pci/ioapic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 205af8d..22436f7 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -125,3 +125,5 @@ static void __exit ioapic_exit(void)
 
 module_init(ioapic_init);
 module_exit(ioapic_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.1

