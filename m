Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1LGQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:56:24 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:32925 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291Ab1LGQ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:56:22 -0500
X-Sasl-enc: vNWAx47sSbEy3k/pphoSSDRGqbjkMKsVutD+hYq7pFEr 1323276981
Date: Wed, 7 Dec 2011 08:56:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/27] 2.6.32.50-longterm review
Message-ID: <20111207165611.GA19872@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.50 release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, December 9, 2011, 17:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                             |    2 +-
 arch/arm/Kconfig                     |   12 +++++
 arch/arm/kernel/process.c            |    3 +
 arch/x86/include/asm/timer.h         |   23 ++++++++++-
 arch/x86/kernel/mpparse.c            |    2 +-
 arch/x86/oprofile/init.c             |    7 ++-
 drivers/i2c/algos/i2c-algo-bit.c     |    4 +-
 drivers/net/wireless/p54/p54spi.c    |    5 +-
 drivers/pci/hotplug/shpchp_core.c    |    4 +-
 drivers/pci/hotplug/shpchp_hpc.c     |    4 +-
 drivers/scsi/scsi_lib.c              |   12 ++++--
 drivers/staging/comedi/comedi_fops.c |   75 +++++++++++++++++++++++++---------
 drivers/staging/usbip/vhci_rx.c      |   10 +++--
 drivers/usb/host/whci/qset.c         |    2 +-
 drivers/usb/serial/ftdi_sio.c        |    1 +
 drivers/usb/serial/ftdi_sio_ids.h    |    1 +
 drivers/usb/serial/option.c          |    1 +
 drivers/usb/storage/unusual_devs.h   |    7 +++
 fs/cifs/misc.c                       |    3 +
 fs/ecryptfs/crypto.c                 |    4 +-
 kernel/irq/manage.c                  |    5 ++-
 kernel/time/clockevents.c            |    1 +
 kernel/time/tick-broadcast.c         |    2 +-
 kernel/time/timekeeping.c            |    4 ++
 net/core/dev.c                       |    1 +
 net/sunrpc/xprtsock.c                |    3 +-
 net/wireless/nl80211.c               |    4 +-
 sound/pci/lx6464es/lx_core.c         |   16 +++++--
 28 files changed, 164 insertions(+), 54 deletions(-)
