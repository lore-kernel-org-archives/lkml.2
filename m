Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0LLSQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:16:54 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:42875
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753762Ab0LLSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:16:49 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
Subject: [PATCH 2/3] Staging: rt2860: Avoid extern in .c file
Date: Sun, 12 Dec 2010 18:56:30 +0100
Message-Id: <1292176591-26081-3-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rt28xx_close and rt28xx_open are already declared in a file included in
rt_config.h, so there is no need to declare them again.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rt2860/pci_main_dev.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
index 321facd..628559d 100644
--- a/drivers/staging/rt2860/pci_main_dev.c
+++ b/drivers/staging/rt2860/pci_main_dev.c
@@ -50,9 +50,6 @@ MODULE_ALIAS("rt3090sta");
 /* */
 /* Function declarations */
 /* */
-extern int rt28xx_close(IN struct net_device *net_dev);
-extern int rt28xx_open(struct net_device *net_dev);
-
 static void __devexit rt2860_remove_one(struct pci_dev *pci_dev);
 static int __devinit rt2860_probe(struct pci_dev *pci_dev,
 				  const struct pci_device_id *ent);
-- 
1.7.2.3

