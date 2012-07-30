Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2G3Rbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:31:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36077 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2G3Rbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:31:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 00/41] 3.0.39-rc2 stable review
Date: Mon, 30 Jul 2012 10:30:59 -0700
Message-Id: <20120730172901.306897424@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0.39-rc1 had a few problems, so I figured we should do a -rc2 just to
ensure that it's all working properly.  Here it is, please test.

There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Aug  1 17:29:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.39-rc2.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 .../trace/postprocess/trace-vmscan-postprocess.pl  |    8 +-
 Makefile                                           |    4 +-
 arch/mips/include/asm/thread_info.h                |    4 +-
 arch/mips/kernel/vmlinux.lds.S                     |    3 +-
 drivers/base/memory.c                              |   58 ++--
 drivers/md/dm-raid1.c                              |    2 +-
 drivers/md/dm-region-hash.c                        |    5 +-
 fs/btrfs/disk-io.c                                 |    5 +-
 fs/cifs/readdir.c                                  |    7 +-
 fs/hugetlbfs/inode.c                               |    3 +-
 fs/nfs/internal.h                                  |    2 +-
 fs/nfs/write.c                                     |    4 +-
 fs/ubifs/sb.c                                      |    8 +-
 include/linux/cpuset.h                             |   47 ++--
 include/linux/fs.h                                 |   11 +-
 include/linux/init_task.h                          |    8 +
 include/linux/memcontrol.h                         |    3 +-
 include/linux/migrate.h                            |   23 +-
 include/linux/mmzone.h                             |   14 +
 include/linux/sched.h                              |    2 +-
 include/linux/swap.h                               |    7 +-
 include/trace/events/vmscan.h                      |   85 +++++-
 kernel/cpuset.c                                    |   63 ++---
 kernel/fork.c                                      |    3 +
 kernel/time/ntp.c                                  |    8 +-
 mm/compaction.c                                    |   26 +-
 mm/filemap.c                                       |   11 +-
 mm/hugetlb.c                                       |   13 +-
 mm/memcontrol.c                                    |    3 +-
 mm/memory-failure.c                                |    2 +-
 mm/memory_hotplug.c                                |    2 +-
 mm/mempolicy.c                                     |   30 +-
 mm/migrate.c                                       |  240 ++++++++++------
 mm/page_alloc.c                                    |  118 +++++---
 mm/slab.c                                          |   13 +-
 mm/slub.c                                          |   40 ++-
 mm/vmscan.c                                        |  296 ++++++++++++++++----
 mm/vmstat.c                                        |    2 +-
 38 files changed, 827 insertions(+), 356 deletions(-)


