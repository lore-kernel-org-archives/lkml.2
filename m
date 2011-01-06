Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1AFWYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:24:00 -0500
Received: from kroah.org ([198.145.64.141]:55696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1AFWX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/36] ip2: fix compiler warning on ip2main_pci_tbl
Date: Thu,  6 Jan 2011 14:23:17 -0800
Message-Id: <1294352605-31906-28-git-send-email-gregkh@suse.de>
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

Annotate ip2main_pci_tbl as '__used' to fix following warning:

  CC      drivers/char/ip2/ip2main.o
drivers/char/ip2/ip2main.c:3227: warning: ‘ip2main_pci_tbl’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/ip2/ip2main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index fcd02ba..c3a0253 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -3224,7 +3224,7 @@ ip2trace (unsigned short pn, unsigned char cat, unsigned char label, unsigned lo
 
 MODULE_LICENSE("GPL");
 
-static struct pci_device_id ip2main_pci_tbl[] __devinitdata = {
+static struct pci_device_id ip2main_pci_tbl[] __devinitdata __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_COMPUTONE, PCI_DEVICE_ID_COMPUTONE_IP2EX) },
 	{ }
 };
-- 
1.7.3.2

