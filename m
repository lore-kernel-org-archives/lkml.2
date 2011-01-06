Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1AFWYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:24:06 -0500
Received: from kroah.org ([198.145.64.141]:55692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab1AFWX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>, Roger Wolff <R.E.Wolff@BitWizard.nl>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/36] specialix: fix compiler warning on specialix_pci_tbl
Date: Thu,  6 Jan 2011 14:23:16 -0800
Message-Id: <1294352605-31906-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Annotate specialx_pci_tbl as '__used' to fix following warning:

  CC      drivers/char/specialix.o
drivers/char/specialix.c:2358: warning: ‘specialx_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Roger Wolff <R.E.Wolff@BitWizard.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/specialix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 9f8495b..499bb0f 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -2356,7 +2356,7 @@ static void __exit specialix_exit_module(void)
 	func_exit();
 }
 
-static struct pci_device_id specialx_pci_tbl[] __devinitdata = {
+static struct pci_device_id specialx_pci_tbl[] __devinitdata __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_IO8) },
 	{ }
 };
-- 
1.7.3.2

