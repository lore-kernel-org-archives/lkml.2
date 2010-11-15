Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab0KOUOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:14:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1363 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933708Ab0KOUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:13 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] sound/pci/asihpi/hpioctl.c: Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:14:02 -0800
Message-Id: <1741bc5f7050b5ebb7014b8d93fdb70490ec7f06.1289851770.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/pci/asihpi/hpioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/asihpi/hpioctl.c b/sound/pci/asihpi/hpioctl.c
index 62895a7..22dbd91 100644
--- a/sound/pci/asihpi/hpioctl.c
+++ b/sound/pci/asihpi/hpioctl.c
@@ -435,7 +435,7 @@ void __devexit asihpi_adapter_remove(struct pci_dev *pci_dev)
 	struct hpi_message hm;
 	struct hpi_response hr;
 	struct hpi_adapter *pa;
-	pa = (struct hpi_adapter *)pci_get_drvdata(pci_dev);
+	pa = pci_get_drvdata(pci_dev);
 
 	hpi_init_message_response(&hm, &hr, HPI_OBJ_SUBSYSTEM,
 		HPI_SUBSYS_DELETE_ADAPTER);
-- 
1.7.3.1.g432b3.dirty

