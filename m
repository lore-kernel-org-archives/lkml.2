Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2GZVO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:14:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47034 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2GZVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:14:24 -0400
Date: Thu, 26 Jul 2012 14:14:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/23] 3.4.7-stable review
Message-ID: <20120726211420.GA7678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.7 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jul 28 21:14:04 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                            |    4 +--
 arch/arm/plat-s5p/clock.c           |    1 +
 arch/mips/include/asm/thread_info.h |    4 +--
 arch/mips/kernel/vmlinux.lds.S      |    3 +-
 drivers/hid/hid-core.c              |    1 +
 drivers/hid/hid-ids.h               |    6 ++++
 drivers/hid/hid-input.c             |    3 ++
 drivers/hid/hid-multitouch.c        |    4 +++
 drivers/hid/usbhid/hid-quirks.c     |    1 +
 drivers/md/dm-raid1.c               |    3 +-
 drivers/md/dm-region-hash.c         |    5 ++-
 drivers/md/dm-thin.c                |    6 +++-
 drivers/md/md.c                     |   36 ++++++++++++-------
 drivers/md/raid1.c                  |   10 ++++--
 drivers/target/target_core_cdb.c    |    2 +-
 drivers/target/target_core_pr.c     |    7 ++--
 drivers/target/tcm_fc/tfc_cmd.c     |    2 ++
 fs/cifs/cifssmb.c                   |   30 ++++++++++++++++
 fs/cifs/connect.c                   |   18 ++++++++++
 fs/cifs/readdir.c                   |    7 ++--
 fs/exofs/ore.c                      |    8 +----
 fs/exofs/ore_raid.c                 |   67 +++++++++++++++++++----------------
 fs/ext4/ioctl.c                     |    1 -
 fs/nfs/objlayout/objio_osd.c        |    9 +++--
 fs/ubifs/sb.c                       |    8 +++--
 kernel/time/ntp.c                   |    8 +++--
 mm/vmscan.c                         |    5 ++-
 27 files changed, 184 insertions(+), 75 deletions(-)

