Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1JQSat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:30:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1JQSas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:30:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=r28mc3z5oXYe4E86XCZ0IlIcuG6twMNnNzg6mTLMcK2UAYc2NfzGHUjTIInwpIWpV
	fYH11U1sJ193v1IeiELNg==
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv6 0/3] get rid of USB_GADGET_{DUAL,SUPER}SPEED
Date: Mon, 17 Oct 2011 11:30:37 -0700
Message-Id: <cover.1318875728.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Sorry for the delay.

Rebased on top of <git://gitorious.org/usb/usb.git gadget>.

This has been only compile-tested.

Michal Nazarewicz (3):
  usb: gadget: replace “is_dualspeed” with “max_speed”
  usb: gadget: rename usb_gadget_driver::speed to max_speed
  usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED

 Documentation/feature-removal-schedule.txt |    7 +++++
 drivers/usb/gadget/Kconfig                 |   30 --------------------
 drivers/usb/gadget/amd5536udc.c            |    4 +-
 drivers/usb/gadget/at91_udc.c              |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c        |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c           |    9 ++++--
 drivers/usb/gadget/composite.c             |    9 +-----
 drivers/usb/gadget/dbgp.c                  |    2 +-
 drivers/usb/gadget/dummy_hcd.c             |   15 +++++-----
 drivers/usb/gadget/epautoconf.c            |    6 ++--
 drivers/usb/gadget/file_storage.c          |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c            |    6 ++--
 drivers/usb/gadget/fsl_udc_core.c          |    6 ++--
 drivers/usb/gadget/fusb300_udc.c           |    4 +-
 drivers/usb/gadget/goku_udc.c              |    3 +-
 drivers/usb/gadget/imx_udc.c               |    2 +-
 drivers/usb/gadget/inode.c                 |   17 +++--------
 drivers/usb/gadget/langwell_udc.c          |    2 +-
 drivers/usb/gadget/m66592-udc.c            |    4 +-
 drivers/usb/gadget/mv_udc_core.c           |    2 +-
 drivers/usb/gadget/net2272.c               |    4 +-
 drivers/usb/gadget/net2280.c               |    4 +-
 drivers/usb/gadget/omap_udc.c              |    3 +-
 drivers/usb/gadget/pch_udc.c               |    4 +-
 drivers/usb/gadget/printer.c               |   41 +++++-----------------------
 drivers/usb/gadget/pxa25x_udc.c            |    2 +-
 drivers/usb/gadget/pxa27x_udc.c            |    2 +-
 drivers/usb/gadget/r8a66597-udc.c          |    4 +-
 drivers/usb/gadget/s3c-hsotg.c             |    6 ++--
 drivers/usb/gadget/s3c-hsudc.c             |    6 ++--
 drivers/usb/gadget/s3c2410_udc.c           |    4 +-
 drivers/usb/gadget/u_ether.c               |    7 -----
 drivers/usb/gadget/udc-core.c              |   26 +++++++++++++----
 drivers/usb/musb/musb_gadget.c             |    4 +-
 drivers/usb/renesas_usbhs/mod_gadget.c     |    4 +-
 include/linux/usb/gadget.h                 |   29 +++++---------------
 36 files changed, 108 insertions(+), 176 deletions(-)

-- 
1.7.3.1

