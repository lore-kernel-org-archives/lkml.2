Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2FNX5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:57:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2FNX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:56:51 -0400
Date: Thu, 14 Jun 2012 16:56:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/20] 3.0.35-stable review
Message-ID: <20120614235648.GA6552@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.35 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun 16 23:56:43 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.35-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                   |    4 +-
 arch/powerpc/kernel/module_32.c            |   11 +++---
 arch/x86/crypto/aesni-intel_asm.S          |    6 ++-
 arch/x86/kernel/cpu/mcheck/mce_amd.c       |   55 ++++++++++++++++++++++------
 drivers/acpi/video.c                       |    5 ++-
 drivers/char/agp/intel-agp.c               |    1 +
 drivers/char/agp/intel-agp.h               |    1 +
 drivers/hwmon/fam15h_power.c               |    8 ++--
 drivers/net/can/c_can/c_can.c              |   16 ++++----
 drivers/net/can/c_can/c_can.h              |    1 +
 drivers/net/e1000/e1000.h                  |    2 +
 drivers/net/e1000/e1000_main.c             |   18 ++++-----
 drivers/net/usb/sierra_net.c               |   14 +++++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    2 +-
 fs/fuse/dir.c                              |    1 +
 fs/fuse/fuse_i.h                           |    3 ++
 fs/fuse/inode.c                            |   17 ++++++++-
 kernel/sched.c                             |    9 ++---
 lib/btree.c                                |    4 +-
 mm/hugetlb.c                               |   29 ++++++++++++---
 mm/vmalloc.c                               |   11 +++---
 net/mac80211/iface.c                       |   12 ++++++
 net/mac80211/offchannel.c                  |   16 ++++++++
 net/wireless/util.c                        |   19 +++++++++-
 24 files changed, 196 insertions(+), 69 deletions(-)

