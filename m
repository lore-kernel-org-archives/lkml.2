Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab1CYX5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:57:50 -0400
Received: from kroah.org ([198.145.64.141]:48852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab1CYX5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:57:47 -0400
Date: Fri, 25 Mar 2011 16:56:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/23] 2.6.32.36-longterm review
Message-ID: <20110325235654.GA24416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.36 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, March 17, 2011, 23:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.36-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                            |    2 +-
 arch/x86/kernel/head64.c            |    3 --
 arch/x86/kernel/setup.c             |    5 ++++
 arch/x86/mm/init.c                  |   19 --------------
 arch/x86/mm/init_64.c               |   11 ++++----
 arch/x86/xen/mmu.c                  |   13 +++++----
 drivers/firmware/dcdbas.c           |    4 ++-
 drivers/input/xen-kbdfront.c        |   45 ++++++++++++++++++----------------
 drivers/media/video/uvc/uvc_video.c |   14 +++++++----
 drivers/pci/hotplug/acpiphp_glue.c  |    1 +
 drivers/pci/pci-sysfs.c             |    7 ++++-
 drivers/usb/class/cdc-acm.c         |    7 ++++-
 drivers/usb/host/ehci-q.c           |   12 ---------
 drivers/usb/misc/uss720.c           |    7 ++---
 drivers/video/console/tileblit.c    |    2 +-
 fs/aio.c                            |    4 +-
 fs/dcache.c                         |    3 ++
 fs/ext3/super.c                     |    7 +++++
 fs/nfsd/nfs4proc.c                  |    4 +-
 fs/nfsd/nfs4xdr.c                   |    5 +---
 fs/proc/array.c                     |    4 +-
 fs/proc/task_mmu.c                  |    4 +-
 kernel/signal.c                     |   16 +++++++++---
 mm/shmem.c                          |    1 +
 net/sunrpc/xprtsock.c               |    2 +
 25 files changed, 106 insertions(+), 96 deletions(-)
