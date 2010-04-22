Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0DVTnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:43:40 -0400
Received: from kroah.org ([198.145.64.141]:41282 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab0DVT3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:20 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.662047032@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mundt <lethal@linux-sh.org>, Mike Travis <travis@sgi.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       maximilian attems <max@stro.at>
Subject: [138/197] PCI: kill off pci_register_set_vga_state() symbol export.
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mundt <lethal@linux-sh.org>

commit ded1d8f29b4d315a2093cafc3ee17ac870a87972 upstream.

When pci_register_set_vga_state() was made __init, the EXPORT_SYMBOL() was
retained, which now leaves us with a section mismatch.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2794,7 +2794,6 @@ EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
-EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);


