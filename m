Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab0EYSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:16:57 -0400
Received: from kroah.org ([198.145.64.141]:44297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab0EYSQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:16:55 -0400
Date: Tue, 25 May 2010 11:12:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/25] 2.6.27.47-stable review, take 2
Message-ID: <20100525181259.GA18630@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here's the second try at getting a new 2.6.27-stable release out the
door.  A number of missed patches were added, and some were dropped due
to issues that people had with them.

Please let me know if anyone has any problems with the patches this time
around.

Responses should be made by Wed May 26, 22:00:00 UTC 2010
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.47-rc2.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                             |    2 +-
 arch/x86/kernel/process.c            |    6 +-
 drivers/acpi/processor_idle.c        |   13 ++-
 drivers/ata/libata-eh.c              |    6 +-
 drivers/char/tty_io.c                |    2 +
 drivers/hwmon/w83781d.c              |   26 ++--
 drivers/i2c/busses/i2c-i801.c        |    6 +-
 drivers/i2c/busses/i2c-tiny-usb.c    |   12 +-
 drivers/i2c/i2c-core.c               |   24 +++-
 drivers/scsi/megaraid/megaraid_sas.c |   18 +++-
 drivers/usb/core/inode.c             |    4 +-
 fs/ext4/balloc.c                     |   88 ++++++++++---
 fs/ext4/ext4.h                       |   13 ++
 fs/ext4/ext4_sb.h                    |    1 +
 fs/ext4/inode.c                      |  229 ++++++++++++++++++++++++----------
 fs/ext4/mballoc.c                    |   39 ++++---
 fs/ext4/super.c                      |    8 +-
 fs/nfs/client.c                      |    2 +
 fs/nfs/dir.c                         |    2 +
 fs/nfsd/nfs4xdr.c                    |    8 +-
 include/linux/percpu_counter.h       |   12 +--
 include/linux/security.h             |    6 +
 include/linux/writeback.h            |    1 -
 kernel/time/clockevents.c            |   16 ++-
 kernel/time/tick-broadcast.c         |    7 +-
 kernel/trace/trace.c                 |    2 +-
 lib/percpu_counter.c                 |    8 +-
 mm/mmap.c                            |    3 +-
 mm/nommu.c                           |    3 +-
 mm/page-writeback.c                  |    2 -
 mm/shmem.c                           |    8 +-
 net/sunrpc/svc_xprt.c                |   25 +++-
 security/security.c                  |    9 ++
 sound/pci/mixart/mixart.c            |   24 ++--
 34 files changed, 433 insertions(+), 202 deletions(-)
