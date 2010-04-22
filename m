Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab0DVUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:25:57 -0400
Received: from kroah.org ([198.145.64.141]:59615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789Ab0DVUAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:00:06 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:08 2010
Message-Id: <20100422195408.641594603@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joseph Chan <josephchan@via.com.tw>, Jeff Garzik <jgarzik@redhat.com>
Subject: [039/139] pata_via: Add VIA VX900 support
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: JosephChan@via.com.tw <JosephChan@via.com.tw>

commit 4f1deba435ef75380c1d06fda860c7a15ea16fdf upstream.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_via.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -697,6 +697,7 @@ static const struct pci_device_id via[]
 	{ PCI_VDEVICE(VIA, 0x3164), },
 	{ PCI_VDEVICE(VIA, 0x5324), },
 	{ PCI_VDEVICE(VIA, 0xC409), VIA_IDFLAG_SINGLE },
+	{ PCI_VDEVICE(VIA, 0x9001), VIA_IDFLAG_SINGLE },
 
 	{ },
 };


