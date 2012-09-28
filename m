Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab2I1UlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:41:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38816 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759581Ab2I1UlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:41:11 -0400
X-Sasl-enc: ZZBYpt8phQX+AS+Cz6uAMke/w9apiZypEUdvxs3Dq+U9 1348864870
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 040/127] ahci: Add alternate identifier for the 88SE9172
Date: Fri, 28 Sep 2012 13:33:33 -0700
Message-Id: <20120928203050.529297267@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -394,6 +394,8 @@ static const struct pci_device_id ahci_p
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(0x1b4b, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(0x1b4b, 0x9192),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 


