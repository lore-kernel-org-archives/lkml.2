Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab0KLVlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:41:21 -0500
Received: from kroah.org ([198.145.64.141]:41597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab0KLVlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:41:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/19] 8250: add support for Kouwell KW-L221N-2
Date: Fri, 12 Nov 2010 13:40:52 -0800
Message-Id: <1289598066-10112-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101112213215.GB9294@kroah.com>
References: <20101112213215.GB9294@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

Add support for Kouwell KW-L221N-2 card.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250_pci.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 53be4d3..2ada93e 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2863,6 +2863,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL,
 		0, 0,
 		pbn_b0_4_1152000 },
+	{	PCI_VENDOR_ID_OXSEMI, 0x9505,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_bt_2_921600 },
 
 		/*
 		 * The below card is a little controversial since it is the
-- 
1.7.1

