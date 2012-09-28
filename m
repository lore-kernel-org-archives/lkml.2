Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048Ab2I1S6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:09 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956Ab2I1S6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 084/262] ahci: Add alternate identifier for the 88SE9172
Date: Fri, 28 Sep 2012 11:50:13 -0700
Message-Id: <20120928183008.101630170@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 17c60c6b763cb5b83b0185e7d38d01d18e55a05a upstream.

This can also appear as 0x9192. Reported in bugzilla and confirmed with the
board documentation for these boards.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=42970
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -396,6 +396,8 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(0x1b4b, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(0x1b4b, 0x9192),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 


