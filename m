Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab1CEBHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:07:03 -0500
Received: from kroah.org ([198.145.64.141]:47713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab1CEBFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:05 -0500
Date: Fri, 4 Mar 2011 17:04:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/18] 2.6.32.32-longterm review
Message-ID: <20110305010410.GA18668@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.32 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Tuesday March 8 2011, 00:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.32-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                             |    2 +-
 arch/x86/include/asm/smpboot_hooks.h |    2 +-
 drivers/gpu/drm/drm_irq.c            |    3 +-
 drivers/hid/hid-core.c               |    1 +
 drivers/hid/hid-cypress.c            |    2 +
 drivers/hid/hid-ids.h                |    1 +
 drivers/mfd/ucb1x00-ts.c             |   12 ++++++--
 drivers/net/e1000e/netdev.c          |    3 +-
 drivers/net/netxen/netxen_nic_hw.c   |    3 ++
 drivers/net/r8169.c                  |    6 ++++
 drivers/net/wireless/p54/p54usb.c    |    1 +
 drivers/usb/misc/iowarrior.c         |    2 +-
 drivers/virtio/virtio_pci.c          |    1 +
 fs/cifs/cifsproto.h                  |    2 +-
 fs/cifs/cifssmb.c                    |    4 ++-
 fs/cifs/file.c                       |   17 ++++++-----
 fs/ext2/namei.c                      |    9 +----
 fs/fuse/file.c                       |   52 +++++++++++++++++++++++++++++----
 fs/fuse/fuse_i.h                     |    6 +++-
 fs/ocfs2/refcounttree.c              |    7 +++-
 include/drm/drmP.h                   |    2 +-
 include/net/sctp/command.h           |    1 +
 kernel/time/tick-broadcast.c         |   10 ++++++
 kernel/time/tick-common.c            |    6 +++-
 kernel/time/tick-internal.h          |    3 ++
 net/dccp/input.c                     |    7 ++--
 net/ipv4/devinet.c                   |   30 +++++++++++++------
 net/sctp/sm_make_chunk.c             |   15 ----------
 net/sctp/sm_sideeffect.c             |   26 +++++++++++++++++
 net/sctp/sm_statefuns.c              |    8 ++++-
 30 files changed, 177 insertions(+), 67 deletions(-)
