Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2DXWdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:33:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49634 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab2DXWdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:33:12 -0400
Date: Tue, 24 Apr 2012 15:33:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/42] 3.0.30-stable review
Message-ID: <20120424223311.GA8456@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.30 release.
There are 42 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Apr 26 22:32:52 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.30-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                   |    4 +-
 crypto/sha512_generic.c                    |    2 +-
 drivers/bluetooth/ath3k.c                  |    2 +
 drivers/bluetooth/btusb.c                  |    1 +
 drivers/hwmon/fam15h_power.c               |   39 ++++++++++++++++
 drivers/media/rc/winbond-cir.c             |    1 +
 drivers/net/davinci_mdio.c                 |    5 ++
 drivers/net/wireless/rt2x00/rt2800usb.c    |   35 +++++++-------
 drivers/pci/quirks.c                       |   34 ++++++++++++++
 drivers/spi/spi.c                          |    2 +-
 drivers/tty/amiserial.c                    |    4 +-
 drivers/tty/serial/clps711x.c              |   14 +++---
 drivers/tty/serial/pch_uart.c              |    4 +-
 drivers/usb/core/hub.c                     |    3 --
 drivers/usb/core/message.c                 |    6 +--
 drivers/usb/gadget/f_fs.c                  |    2 +-
 drivers/usb/host/ehci-hcd.c                |    7 ++-
 drivers/usb/misc/yurex.c                   |   10 ++--
 drivers/usb/musb/omap2430.c                |    9 ++--
 drivers/usb/serial/cp210x.c                |    9 ++--
 drivers/usb/serial/sierra.c                |    6 ++-
 drivers/uwb/hwa-rc.c                       |    3 +-
 drivers/uwb/neh.c                          |   12 ++++-
 drivers/xen/gntdev.c                       |    2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c |   69 +++++++++++++++++++++-------
 fs/btrfs/ctree.h                           |    2 +-
 fs/eventpoll.c                             |    4 ++
 fs/ext4/extents.c                          |    2 +-
 fs/jbd2/commit.c                           |    4 +-
 fs/lockd/clnt4xdr.c                        |    2 +-
 fs/lockd/clntxdr.c                         |    2 +-
 fs/nfsd/nfs3xdr.c                          |   22 ++++-----
 fs/ocfs2/alloc.c                           |    2 +-
 fs/ocfs2/refcounttree.c                    |   12 ++---
 fs/ocfs2/suballoc.c                        |    4 +-
 mm/swap_state.c                            |    2 +-
 net/wireless/util.c                        |    2 +-
 sound/pci/hda/patch_conexant.c             |    9 +++-
 tools/perf/util/hist.c                     |    4 +-
 39 files changed, 252 insertions(+), 106 deletions(-)

