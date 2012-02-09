Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2BIUVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:21:45 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46628 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab2BIUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:21:43 -0500
Date: Thu, 9 Feb 2012 12:20:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 3.3-rc3
Message-ID: <20120209202039.GA22131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:

  Linux 3.3-rc2 (2012-01-31 13:31:54 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git driver-core-3.3-rc3

for you to fetch changes up to 29bb5d4fd3140a7d5d02d858118c74a45f15c296:

  driver-core: cpu: fix kobject warning when hotplugging a cpu (2012-02-08 15:11:17 -0800)

----------------------------------------------------------------
Driver core fixes for the 3.3-rc3 tree.

A few fixes for kobject warnings that have popped up in the cpu hotplug path,
and a regression fix for the speed of the hotplug memory code.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Greg Kroah-Hartman (2):
      driver core: cpu: remove kernel warning when removing a cpu
      driver-core: cpu: fix kobject warning when hotplugging a cpu

Randy Dunlap (1):
      docbook: fix fatal errors in device-drivers docbook and add DMA Management section

Yinghai Lu (2):
      drivers/base/memory.c: fix memory_dev_init() long delay
      ACPI: remove duplicated lines of merging problems with acpi_processor_add

 Documentation/DocBook/device-drivers.tmpl |   12 +++++++++-
 drivers/acpi/processor_driver.c           |    7 ------
 drivers/base/cpu.c                        |   21 +++++++++++++++++++
 drivers/base/memory.c                     |   31 ++++++++++++++++++++++++----
 drivers/base/node.c                       |    8 +++++++
 5 files changed, 65 insertions(+), 14 deletions(-)
