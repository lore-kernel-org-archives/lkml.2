Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0IRStD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:49:03 -0400
Received: from kroah.org ([198.145.64.141]:38941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab0IRSsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:48:36 -0400
Date: Sat, 18 Sep 2010 11:46:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/11] 2.6.27.54-stable review
Message-ID: <20100918184651.GA14224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.54 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by September 20, 2010 19:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.54-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                           |    2 +-
 arch/ia64/include/asm/compat.h     |    2 +-
 arch/powerpc/include/asm/compat.h  |    2 +-
 arch/s390/include/asm/compat.h     |    2 +-
 arch/sparc/include/asm/compat.h    |    2 +-
 arch/x86/ia32/ia32entry.S          |   14 +++++++-------
 drivers/hwmon/f75375s.c            |    6 +++---
 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 drivers/power/apm_power.c          |    1 +
 include/asm-mips/compat.h          |    2 +-
 include/asm-parisc/compat.h        |    2 +-
 include/asm-x86/compat.h           |    2 +-
 include/linux/compat.h             |    2 ++
 kernel/compat.c                    |   22 ++++++++++++++++++++++
 kernel/trace/ftrace.c              |    2 +-
 mm/bounce.c                        |    2 +-
 net/irda/irlan/irlan_common.c      |    2 +-
 sound/core/seq/oss/seq_oss_init.c  |    9 ++++-----
 18 files changed, 51 insertions(+), 27 deletions(-)
