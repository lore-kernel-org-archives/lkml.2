Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1LOTmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:42:00 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39233 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab1LOTl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:41:58 -0500
X-Sasl-enc: diyArKhT91kqTJEtOTJ57iVK7RAGA0Nj8qM8MKW+w4dW 1323978117
Date: Thu, 15 Dec 2011 11:41:49 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] more USB fixes for 3.2
Message-ID: <20111215194149.GA24990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a small number of USB fixes and new device ids for the 3.2 tree.

All pretty minor, full details are in the shortlog below.

Please pull from:
	git.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb.git/ usb-linus

All have been in the -next releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c          |   10 ++++++++++
 drivers/usb/gadget/f_mass_storage.c  |    1 +
 drivers/usb/renesas_usbhs/mod.c      |    2 +-
 drivers/usb/renesas_usbhs/mod_host.c |    1 +
 drivers/usb/serial/option.c          |    7 ++++++-
 5 files changed, 19 insertions(+), 2 deletions(-)

---------------

Alex Hermann (1):
      usb: option: Add Huawei E398 controlling interfaces

Bjørn Mork (1):
      USB: option: Removing one bogus and adding some new Huawei combinations

Krzysztof Hałasa (1):
      USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.

Kuninori Morimoto (2):
      usb: renesas_usbhs: typofix: irq_dtch control DTCHE
      usb: renesas_usbhs: add hcd->has_tt for low/full speed

Yu Xu (1):
      usb: gadget: storage: release superspeed descriptors.

