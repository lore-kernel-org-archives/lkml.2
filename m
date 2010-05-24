Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0EXWlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:41:40 -0400
Received: from kroah.org ([198.145.64.141]:42333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab0EXWiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:38:18 -0400
Date: Mon, 24 May 2010 15:35:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/24] 2.6.27.47-stable review
Message-ID: <20100524223544.GA13721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.47 release.
There are 24 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wed May 26, 22:00:00 UTC 2010
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.47-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                             |    2 +-
 arch/x86/kernel/process.c            |    6 +-
 drivers/acpi/processor_idle.c        |   13 +-
 drivers/ata/libata-eh.c              |    6 +-
 drivers/char/tty_io.c                |    2 +
 drivers/i2c/i2c-core.c               |   24 ++-
 drivers/scsi/megaraid/megaraid_sas.c |   18 ++-
 drivers/usb/core/inode.c             |    4 +-
 fs/ext4/balloc.c                     |   88 ++++++++--
 fs/ext4/ext4.h                       |   13 ++
 fs/ext4/ext4_sb.h                    |    1 +
 fs/ext4/inode.c                      |  314 ++++++++++++++++++++++++----------
 fs/ext4/mballoc.c                    |   39 +++--
 fs/ext4/super.c                      |    8 +-
 fs/nfs/client.c                      |    2 +
 fs/nfs/dir.c                         |    2 +
 fs/nfsd/nfs4xdr.c                    |    8 +-
 include/linux/percpu_counter.h       |   12 +-
 include/linux/writeback.h            |   10 +-
 kernel/time/clockevents.c            |   16 +-
 kernel/time/tick-broadcast.c         |    7 +-
 kernel/trace/trace.c                 |    2 +-
 lib/percpu_counter.c                 |    8 +-
 mm/page-writeback.c                  |   16 +-
 net/sunrpc/svc_xprt.c                |   25 ++-
 sound/pci/mixart/mixart.c            |   24 ++-
 26 files changed, 467 insertions(+), 203 deletions(-)
