Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab2BJWuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51143 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab2BJWt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:49:57 -0500
Date: Fri, 10 Feb 2012 14:48:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/21] 2.6.32.57-longterm review
Message-ID: <20120210224858.GA30752@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.57 release.
There are 21 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Mon Feb 13 22:00:00 UTC 2012
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.57-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                              |    2 +-
 drivers/gpu/drm/i915/intel_tv.c       |   16 ++++++++--------
 drivers/infiniband/hw/mlx4/mad.c      |    7 ++-----
 drivers/misc/cb710/core.c             |    1 +
 drivers/staging/android/binder.c      |   13 +++++++++++--
 drivers/staging/asus_oled/asus_oled.c |   10 ++++++++--
 drivers/usb/gadget/f_loopback.c       |    2 +-
 drivers/usb/host/pci-quirks.c         |    6 ++++++
 drivers/usb/serial/ftdi_sio.c         |    1 +
 drivers/usb/serial/ftdi_sio_ids.h     |    7 +++++++
 drivers/video/atmel_lcdfb.c           |    2 +-
 fs/ecryptfs/read_write.c              |    4 ++--
 fs/nfs/nfs4proc.c                     |   29 ++++++++++++++++++++++-------
 fs/nfs/nfs4state.c                    |   19 ++++++++++---------
 fs/udf/super.c                        |    6 ++++++
 include/net/sock.h                    |   15 +--------------
 mm/filemap_xip.c                      |    7 ++++++-
 net/core/skbuff.c                     |   30 ++++++++++++++++++++++++++++++
 net/ipv4/udp.c                        |    4 ++--
 net/sunrpc/xprtsock.c                 |    8 ++------
 20 files changed, 128 insertions(+), 61 deletions(-)
