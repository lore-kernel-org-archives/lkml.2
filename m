Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0LHAe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:34:28 -0500
Received: from kroah.org ([198.145.64.141]:54745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab0LHAeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:25 -0500
Date: Tue, 7 Dec 2010 16:32:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/44] 2.6.27.57-stable review
Message-ID: <20101208003205.GA4286@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.57 release.
There are 44 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, December 9, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.57-rc1.gz
and the diffstat can be found below.

Note, this is going to be my last .27 kernel release before handing it
off to someone else for "longterm" support.

thanks,

greg k-h


 Makefile                                   |    2 +-
 arch/arm/lib/findbit.S                     |    6 ++-
 arch/um/os-Linux/time.c                    |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 +
 block/blk-map.c                            |    2 +
 drivers/ata/libata-scsi.c                  |    5 ++-
 drivers/char/vt_ioctl.c                    |   11 +++---
 drivers/media/video/ivtv/ivtvfb.c          |    2 +
 drivers/usb/atm/ueagle-atm.c               |    6 ++--
 drivers/usb/core/devio.c                   |    7 ++--
 drivers/usb/host/ehci-hcd.c                |   10 +++---
 drivers/usb/misc/cypress_cy7c63.c          |    6 +--
 drivers/usb/misc/iowarrior.c               |    1 +
 drivers/usb/misc/sisusbvga/sisusb.c        |    1 +
 drivers/usb/misc/trancevibrator.c          |    2 +-
 drivers/usb/misc/usbled.c                  |    2 +-
 drivers/usb/storage/sierra_ms.c            |    2 +-
 fs/bio.c                                   |   14 ++++++++-
 fs/ecryptfs/inode.c                        |    4 ++
 include/net/x25.h                          |    4 ++
 ipc/compat.c                               |    6 +++
 ipc/compat_mq.c                            |    5 +++
 ipc/sem.c                                  |    2 +
 ipc/shm.c                                  |    1 +
 kernel/exit.c                              |    9 +++++
 lib/percpu_counter.c                       |    1 +
 mm/internal.h                              |    2 +-
 mm/memory_hotplug.c                        |    2 +-
 mm/mempolicy.c                             |    2 +-
 net/can/bcm.c                              |    2 +-
 net/core/ethtool.c                         |    2 +-
 net/core/stream.c                          |    8 ++--
 net/decnet/af_decnet.c                     |    2 +
 net/econet/af_econet.c                     |   29 ++++++----------
 net/ipv4/tcp.c                             |   11 +++++--
 net/ipv4/tcp_input.c                       |    2 +
 net/ipv4/udp.c                             |    4 ++-
 net/ipv4/xfrm4_policy.c                    |    4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c    |    1 +
 net/ipv6/route.c                           |   28 ++++++++++++++--
 net/irda/iriap.c                           |    3 +-
 net/irda/parameters.c                      |    4 ++-
 net/rose/af_rose.c                         |    4 +-
 net/sctp/protocol.c                        |    4 ++-
 net/socket.c                               |    4 ++
 net/x25/af_x25.c                           |   47 +++++++++++++++++++++++++++-
 net/x25/x25_facilities.c                   |   32 ++++++++++++++-----
 net/x25/x25_in.c                           |   17 ++++++++--
 48 files changed, 244 insertions(+), 84 deletions(-)


