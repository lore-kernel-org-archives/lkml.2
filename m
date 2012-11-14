Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2KNHu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:50:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2KNHu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:50:58 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 0/6] staging: line6: drop driver-specific dumping code
Date: Wed, 14 Nov 2012 08:50:40 +0100
Message-Id: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line6 driver has compile-time options for dumping USB and MIDI data.
This functionality has been superceded by usbmon and amidi/aseqdump.
These mechanisms can be enabled at run-time and have other features not
in the line6 dumping code.  Therefore it's time to drop the
driver-specific dumping code as part of the effort to clean up the driver
and get it out of staging.

Stefan Hajnoczi (6):
  staging: line6: drop control URB dumping code
  staging: line6: drop CONTROL from CONFIG_LINE6_USB_DUMP_ANY
  staging: line6: drop unused CONFIG_LINE6_USB_DUMP_CTRL
  staging: line6: drop MIDI dumping code
  staging: line6: drop MIDI from CONFIG_LINE6_USB_DUMP_ANY
  staging: line6: drop unused CONFIG_LINE6_USB_DUMP_MIDI

 drivers/staging/line6/Kconfig  | 18 ------------------
 drivers/staging/line6/driver.c | 39 ---------------------------------------
 drivers/staging/line6/driver.h |  2 +-
 drivers/staging/line6/midi.c   |  6 ------
 4 files changed, 1 insertion(+), 64 deletions(-)

-- 
1.8.0

