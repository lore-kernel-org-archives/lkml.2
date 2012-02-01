Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab2BAV7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:59:40 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35293 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756Ab2BAVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:34 -0500
X-Sasl-enc: KVnTUA0TDya6OUXH2WjY6VKvQ3zebBDJVgqbOfnmWMp9 1328130453
Date: Wed, 1 Feb 2012 13:00:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/20] 2.6.32.56-longterm review
Message-ID: <20120201210055.GA25374@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.56 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, February 3, 2012, 20:00:00 UTC
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.56-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                          |    2 +-
 block/scsi_ioctl.c                |   45 ++++++++++++++++++++++++++
 crypto/sha512_generic.c           |   62 ++++++++++++++++++++----------------
 drivers/gpu/drm/drm_auth.c        |    6 +++-
 drivers/gpu/drm/drm_fops.c        |    5 +++
 drivers/hwmon/f71805f.c           |   10 +++---
 drivers/hwmon/sht15.c             |    3 +-
 drivers/md/dm-linear.c            |   12 ++++++-
 drivers/md/dm-mpath.c             |    6 +++
 drivers/mmc/host/mmci.c           |    6 +---
 drivers/scsi/sd.c                 |   11 +++++-
 drivers/usb/class/cdc-wdm.c       |    2 +
 drivers/usb/misc/usbsevseg.c      |    2 +-
 drivers/usb/serial/cp210x.c       |    5 ++-
 drivers/usb/serial/ftdi_sio.c     |    7 +++-
 drivers/usb/serial/ftdi_sio_ids.h |   19 +++++++++++
 drivers/usb/serial/io_ti.c        |   10 +-----
 fs/ecryptfs/crypto.c              |    9 +++--
 fs/ecryptfs/miscdev.c             |   56 ++++++++++++++++++++++-----------
 fs/ecryptfs/read_write.c          |   19 ++++++++---
 include/drm/drmP.h                |    1 +
 include/linux/blkdev.h            |    1 +
 22 files changed, 216 insertions(+), 83 deletions(-)
