Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab2BIUVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:21:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35424 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2BIUVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:21:38 -0500
Date: Thu, 9 Feb 2012 12:19:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.3-rc3
Message-ID: <20120209201944.GA22098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-3.3-rc3

for you to fetch changes up to 90451e6973a5da155c6f315a409ca0a8d3ce6b76:

  USB: usbserial: add new PID number (0xa951) to the ftdi driver (2012-02-03 11:22:44 -0800)

----------------------------------------------------------------
USB fixes for 3.3-rc3

Here are a few minor USB fixes and a bunch of device id updates for the
USB drivers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Cong Wang (1):
      usb: musb: fix a build error on mips

Fabio Estevam (1):
      usb: host: Distinguish Kconfig text for Freescale controllers

Greg Kroah-Hartman (1):
      Merge tag 'for-3.3-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus

Jayachandran C (1):
      usb: Skip PCI USB quirk handling for Netlogic XLP

Kuninori Morimoto (2):
      usb: ch9.h: usb_endpoint_maxp() uses __le16_to_cpu()
      usb: ch9.h: usb_endpoint_maxp() uses __le16_to_cpu()

Milan Kocian (1):
      USB: usbserial: add new PID number (0xa951) to the ftdi driver

Neil Zhang (2):
      usb: otg: mv_otg: Add dependence
      usb: otg: mv_otg: Add dependence

Randy Dunlap (1):
      uwb & wusb & usb wireless controllers: fix kconfig error & build errors

Rui li (1):
      USB: add new zte 3g-dongle's pid to option.c

Shengzhou Liu (1):
      powerpc/usb: fix issue of CPU halt when missing USB PHY clock

Thomas Tuttle (2):
      USB: qcserial: add several new serial devices
      USB: qcserial: don't enable autosuspend

Timo Juhani Lindfors (1):
      usb: gadget: zero: fix bug in loopback autoresume handling

 drivers/usb/gadget/f_loopback.c   |    2 +-
 drivers/usb/host/Kconfig          |    8 +-
 drivers/usb/host/ehci-fsl.c       |   11 +++-
 drivers/usb/host/ehci-fsl.h       |    1 +
 drivers/usb/host/pci-quirks.c     |    6 ++
 drivers/usb/musb/musb_io.h        |    3 +-
 drivers/usb/otg/Kconfig           |    2 +-
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 ++
 drivers/usb/serial/option.c       |  129 ++++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/qcserial.c     |   16 ++++-
 include/linux/usb/ch9.h           |    2 +-
 12 files changed, 175 insertions(+), 13 deletions(-)
