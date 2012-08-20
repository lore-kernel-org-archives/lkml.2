Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2HTT3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:29:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41580 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2HTT3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:29:36 -0400
Date: Mon, 20 Aug 2012 12:29:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] More USB fixes for 3.6-rc3
Message-ID: <20120820192933.GB15744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 731879f8e3d4c61220462160311fa650a8b96abf:

  USB: qcserial: fix port handling on Gobi 1K and 2K+ (2012-08-16 09:48:03 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.6-rc3

for you to fetch changes up to 8f057d7bca549e8f7c1f8e750c75598986f5d9aa:

  gpu/mfd/usb: Fix USB randconfig problems (2012-08-20 11:52:41 -0700)

----------------------------------------------------------------
More USB patches for 3.6-rc3

Here are 10 more USB patches for 3.6-rc3.  They all fix reported
problems (build problems for one of them, and easily repeatable oopses
for the others.)

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (8):
      USB: smsusb: remove __devinit* from the struct usb_device_id table
      USB: jl2005bcd: remove __devinit* from the struct usb_device_id table
      USB: spca506: remove __devinit* from the struct usb_device_id table
      USB: p54usb: remove __devinit* from the struct usb_device_id table
      USB: rtl8187: remove __devinit* from the struct usb_device_id table
      USB: vt6656: remove __devinit* from the struct usb_device_id table
      USB: winbond: remove __devinit* from the struct usb_device_id table
      USB: emi62: remove __devinit* from the struct usb_device_id table

Guenter Roeck (1):
      gpu/mfd/usb: Fix USB randconfig problems

Sven Schnelle (1):
      USB: CDC ACM: Fix NULL pointer dereference

 drivers/gpu/drm/Kconfig                    | 1 +
 drivers/gpu/drm/udl/Kconfig                | 1 +
 drivers/media/dvb/siano/smsusb.c           | 2 +-
 drivers/media/video/gspca/jl2005bcd.c      | 2 +-
 drivers/media/video/gspca/spca506.c        | 2 +-
 drivers/mfd/Kconfig                        | 3 ++-
 drivers/net/wireless/p54/p54usb.c          | 2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 2 +-
 drivers/staging/vt6656/main_usb.c          | 2 +-
 drivers/staging/winbond/wbusb.c            | 2 +-
 drivers/usb/Kconfig                        | 2 +-
 drivers/usb/class/cdc-acm.c                | 3 ++-
 drivers/usb/misc/emi62.c                   | 2 +-
 13 files changed, 15 insertions(+), 11 deletions(-)
