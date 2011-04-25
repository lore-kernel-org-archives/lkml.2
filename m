Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab1DYUxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:53:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34007 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab1DYUYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:19 -0400
Message-Id: <20110425200236.560500623@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jaroslav Kysela <jkysela@redhat.com>, David Milburn <dmilburn@redhat.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [PATCH 082/173] ahci: add device IDs for Ibex Peak ahci controllers
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Milburn <dmilburn@redhat.com>

commit c1f57d9b9846e7366c328f916d1a82d03ba4312c upstream.

Add device IDS for Ibex Peak SATA AHCI Controllers

Signed-off-by: Jaroslav Kysela <jkysela@redhat.com>
Signed-off-by: David Milburn <dmilburn@redhat.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 336eb1e..958c1fa 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -515,10 +515,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a22), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3b22), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x3b23), board_ahci }, /* PCH AHCI */
 	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b29), board_ahci }, /* PCH AHCI */
 	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


