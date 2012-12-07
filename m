Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423184Ab2LGA5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:57:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61767 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423029Ab2LGA5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:57:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/11] 3.0.56-stable review
Date: Thu,  6 Dec 2012 16:56:56 -0800
Message-Id: <20121207005613.189054768@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.56 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Dec  9 00:55:07 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.56-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.56-rc1

Jan Kara <jack@suse.cz>
    scsi: Silence unnecessary warnings about ioctl to partition

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Add no-lvds quirk for Supermicro X7SPA-H

Calvin Walton <calvin.walton@kepstin.ca>
    i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Alan Cox <alan@linux.intel.com>
    ACPI: missing break

Michal Kubecek <mkubecek@suse.cz>
    route: release dst_entry.hh_cache when handling redirects

Mike Galbraith <efault@gmx.de>
    Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Mike Galbraith <mgalbraith@suse.de>
    workqueue: exit rescuer_thread() as TASK_RUNNING

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: soft offline: split thp at the beginning of soft_offline_page()

Jianguo Wu <wujianguo@huawei.com>
    mm/vmemmap: fix wrong use of virt_to_page

Russell King - ARM Linux <linux@arm.linux.org.uk>
    Dove: Fix irq_to_pmu()

Russell King - ARM Linux <linux@arm.linux.org.uk>
    Dove: Attempt to fix PMU/RTC interrupts


-------------

Diffstat:

 Makefile                             |  4 ++--
 arch/arm/mach-dove/include/mach/pm.h |  2 +-
 arch/arm/mach-dove/irq.c             | 14 +++++++++++++-
 block/scsi_ioctl.c                   |  5 ++++-
 drivers/acpi/processor_driver.c      |  1 +
 drivers/gpu/drm/i915/intel_lvds.c    | 16 ++++++++++++++++
 kernel/sched_autogroup.c             |  4 ----
 kernel/sched_autogroup.h             |  5 -----
 kernel/workqueue.c                   |  4 +++-
 mm/memory-failure.c                  |  8 ++++++++
 mm/sparse.c                          | 10 ++++------
 net/ipv4/route.c                     |  4 ++++
 12 files changed, 56 insertions(+), 21 deletions(-)


