Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab0JVSoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:44:46 -0400
Received: from kroah.org ([198.145.64.141]:45956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758864Ab0JVSlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:32 -0400
Date: Fri, 22 Oct 2010 11:40:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/17] 2.6.27.55-stable review
Message-ID: <20101022184048.GA25391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.55 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, October 25, 2010 16:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.55-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                             |    2 +-
 arch/powerpc/kernel/head_64.S        |   18 ++++++++++++------
 block/bsg.c                          |    2 +-
 drivers/dma/mv_xor.c                 |    2 +-
 drivers/media/video/compat_ioctl32.c |   32 +++++++++++++++++++++-----------
 drivers/net/atlx/atl1.c              |    5 +++--
 drivers/net/b44.c                    |    4 ++--
 drivers/net/r6040.c                  |   12 +++++-------
 fs/aio.c                             |    3 +++
 fs/exec.c                            |   14 ++++++++++++++
 include/linux/mm.h                   |    8 +++++++-
 mm/memory.c                          |   15 +++++++++++----
 mm/mmap.c                            |    3 ---
 net/wireless/wext.c                  |    2 +-
 sound/core/control.c                 |    3 +++
 sound/pci/rme9652/hdsp.c             |    1 +
 sound/pci/rme9652/hdspm.c            |    1 +
 17 files changed, 87 insertions(+), 40 deletions(-)
