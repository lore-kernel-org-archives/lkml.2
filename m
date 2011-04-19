Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1DSVHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:07:55 -0400
Received: from kroah.org ([198.145.64.141]:39398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab1DSVEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:25 -0400
Date: Tue, 19 Apr 2011 14:03:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/26] 2.6.33.12-longterm review
Message-ID: <20110419210333.GA17417@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.12 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, April 21, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.12-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 MAINTAINERS                                |    1 -
 Makefile                                   |    2 +-
 arch/ia64/kernel/mca.c                     |    3 +-
 arch/ia64/sn/pci/tioca_provider.c          |    2 +-
 arch/x86/include/asm/msr-index.h           |    4 +
 arch/x86/include/asm/processor.h           |   19 ++++++
 arch/x86/kernel/cpu/amd.c                  |   88 ++++++++++++++++++++++++++++
 arch/x86/kernel/process.c                  |   39 +------------
 arch/x86/lib/semaphore_32.S                |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c |    6 +-
 drivers/net/usb/cdc-phonet.c               |    9 +--
 drivers/usb/core/devices.c                 |   10 ++-
 drivers/usb/host/ehci-q.c                  |   15 +++--
 drivers/usb/host/xhci-mem.c                |   85 +++++++++++++++++++-------
 drivers/usb/host/xhci.h                    |    6 +-
 drivers/usb/serial/ftdi_sio.c              |    5 ++
 drivers/usb/serial/ftdi_sio_ids.h          |   12 ++++
 fs/cifs/connect.c                          |    2 +-
 fs/proc/base.c                             |    9 ++-
 fs/ramfs/file-nommu.c                      |    1 +
 fs/ubifs/debug.c                           |    6 +-
 fs/ubifs/file.c                            |    3 +
 include/linux/pid.h                        |    2 +-
 kernel/pid.c                               |    5 +-
 net/ax25/af_ax25.c                         |    2 +-
 net/rds/rdma.c                             |   11 ++++
 26 files changed, 253 insertions(+), 96 deletions(-)
