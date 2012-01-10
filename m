Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2AJUJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:09:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49144 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756749Ab2AJUJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:09:11 -0500
X-Sasl-enc: QHpu4KwJ2nM0ipwFas9CPwWpdnJyIZ6LA6T0vKcftwHz 1326226150
Date: Tue, 10 Jan 2012 12:09:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/20] 2.6.32.54-longterm review
Message-ID: <20120110200902.GA5674@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.@rel@ release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, January 12, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.54-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/HOWTO                         |    4 +-
 Documentation/development-process/5.Posting |    8 ++--
 Documentation/usb/usbmon.txt                |   14 +++--
 MAINTAINERS                                 |    2 +-
 Makefile                                    |    2 +-
 drivers/base/firmware_class.c               |   14 +++---
 drivers/net/usb/asix.c                      |    6 ++-
 drivers/scsi/device_handler/scsi_dh.c       |    7 ++-
 drivers/usb/class/cdc-acm.c                 |    4 ++
 drivers/usb/core/quirks.c                   |    5 ++-
 drivers/usb/misc/isight_firmware.c          |    6 ++-
 drivers/usb/serial/cp210x.c                 |    1 +
 drivers/usb/serial/omninet.c                |    2 +-
 drivers/usb/storage/usb.c                   |    1 +
 drivers/video/offb.c                        |   52 +++++++++----------
 fs/reiserfs/super.c                         |   27 ++++++----
 fs/xfs/linux-2.6/xfs_acl.c                  |    4 +-
 kernel/cpu.c                                |   74 +++++++++++++++++++++++++++
 18 files changed, 167 insertions(+), 66 deletions(-)
