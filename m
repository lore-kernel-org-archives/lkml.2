Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1KOHx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:53:58 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:48655 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab1KOHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:53:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        usb-storage@lists.one-eyed-alien.net,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 00/13] Sparse fixes
Date: Tue, 15 Nov 2011 09:53:27 +0200
Message-Id: <1321343620-10794-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here are a few sparse fixups for the storage drivers.
Compile tested with allyesconfig and allmodconfig.

Felipe Balbi (13):
  usb: storage: alauda: fix sparse warnings
  usb: storage: cypress: fix sparse warning
  usb: storage: datafab: fix sparse warning
  usb: storage: ene_ub6250: fix sparse warnings
  usb: storage: freecom: fix sparse warning
  usb: storage: isd200: fix sparse warning
  usb: storage: jumpshot: fix sparse warning
  usb: storage: karma: fix sparse warning
  usb: storage: onetouch: fix sparse warning
  usb: storagE: realtek_cr: fix sparse warnings
  usb: storage: sddr09: fix sparse warning
  usb: storage: sddr55: fix sparse warning
  usb: storage: shuttle_usbat: fix sparse warning

 drivers/usb/storage/alauda.c        |    2 +-
 drivers/usb/storage/cypress_atacb.c |    2 +-
 drivers/usb/storage/datafab.c       |    2 +-
 drivers/usb/storage/ene_ub6250.c    |   12 ++++++------
 drivers/usb/storage/freecom.c       |    2 +-
 drivers/usb/storage/isd200.c        |    2 +-
 drivers/usb/storage/jumpshot.c      |    2 +-
 drivers/usb/storage/karma.c         |    2 +-
 drivers/usb/storage/onetouch.c      |    2 +-
 drivers/usb/storage/realtek_cr.c    |   11 +++++------
 drivers/usb/storage/sddr09.c        |    2 +-
 drivers/usb/storage/sddr55.c        |    2 +-
 drivers/usb/storage/shuttle_usbat.c |    2 +-
 13 files changed, 22 insertions(+), 23 deletions(-)

-- 
1.7.8.rc0

