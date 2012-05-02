Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab2EBC2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:28:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48838 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758609Ab2EBC1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:27:43 -0400
From: Matt Turner <mattst88@gmail.com>
To: linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: [PATCH 4/4] alpha: silence 'const' warning in sys_marvel.c
Date: Tue,  1 May 2012 22:27:24 -0400
Message-Id: <1335925644-5192-4-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1335925644-5192-1-git-send-email-mattst88@gmail.com>
References: <1335925644-5192-1-git-send-email-mattst88@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: passing argument 1 of 'pci_find_capability' discards 'const' qualifier from pointer target type

Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/kernel/sys_marvel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 14a4b6a..407accc 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -317,7 +317,7 @@ marvel_init_irq(void)
 }
 
 static int 
-marvel_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+marvel_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct pci_controller *hose = dev->sysdata;
 	struct io7_port *io7_port = hose->sysdata;
-- 
1.7.3.4

