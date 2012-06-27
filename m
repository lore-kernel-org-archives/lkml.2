Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2F0TsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:48:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61471 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2F0TsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:48:21 -0400
Date: Wed, 27 Jun 2012 12:48:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bug fixes for 3.5-rc5
Message-ID: <20120627194817.GA9327@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.5-rc5

for you to fetch changes up to 3fcc8f96829776cf181918461923d1e3bbb831a2:

  USB: CP210x Add 10 Device IDs (2012-06-26 16:14:34 -0700)

----------------------------------------------------------------
USB fixes for 3.5-rc5

Here are some small USB gadget bugfixes, and a few new USB device ids added to
some drivers for the 3.5-rc5 release.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ajay Kumar Gupta (1):
      usb: musb: host: release dma channels if no active io

Alan Stern (2):
      SCSI & usb-storage: add try_rc_10_first flag
      usb-storage: revert commit afff07e61a52 (Add 090c:1000 to unusal-devs)

Alexandre Pereira da Silva (2):
      usb: gadget: lpc32xx_udc: fix build error with debugfs enabled
      usb: phy: Fix Kconfig dependency for Phy drivers

Ben Collins (1):
      usb: gadget: Complete fsl qe/udc driver conversion

Craig Shelley (1):
      USB: CP210x Add 10 Device IDs

Dmitry Shmygov (1):
      USB: option: add id for Cellient MEN-200

Forest Bond (1):
      USB: option: Add USB ID for Novatel Ovation MC551

Greg Kroah-Hartman (2):
      Merge tag 'fixes-for-v3.5-rc3' of git://git.kernel.org/.../balbi/usb into usb-linus
      Merge 3.5-rc4 into usb-linus

Moiz Sonasath (1):
      usb: otg: twl6030-usb: Fix twl writes

Pratyush Anand (1):
      usb: dwc3: fix giveback of queued request in ep_dequeue

 drivers/scsi/sd.c                  |  2 ++
 drivers/usb/Makefile               |  2 +-
 drivers/usb/dwc3/gadget.c          |  3 ++-
 drivers/usb/gadget/fsl_qe_udc.h    |  4 ++--
 drivers/usb/gadget/lpc32xx_udc.c   |  1 +
 drivers/usb/musb/musb_host.c       | 14 ++++++++++++--
 drivers/usb/otg/twl6030-usb.c      | 15 ++++++---------
 drivers/usb/phy/Kconfig            |  4 ++--
 drivers/usb/serial/cp210x.c        | 11 +++++++++++
 drivers/usb/serial/option.c        |  8 ++++++++
 drivers/usb/storage/scsiglue.c     |  6 ++++++
 drivers/usb/storage/unusual_devs.h |  7 -------
 include/scsi/scsi_device.h         |  1 +
 13 files changed, 54 insertions(+), 24 deletions(-)
