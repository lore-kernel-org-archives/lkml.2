Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2GZVOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:14:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55786 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2GZVO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:14:28 -0400
Date: Thu, 26 Jul 2012 14:14:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/40] 3.0.39-stable review
Message-ID: <20120726211424.GA7709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.39 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jul 28 21:14:09 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.39-rc1.gz
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
 include/linux/cpuset.h                             |   45 ++-
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
 mm/slub.c                                          |   39 ++-
 mm/vmscan.c                                        |  289 ++++++++++++++++----
 mm/vmstat.c                                        |    2 +-
 38 files changed, 820 insertions(+), 353 deletions(-)

