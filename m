Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab0ITVpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:45:30 -0400
Received: from kroah.org ([198.145.64.141]:45332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab0ITVp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:45:29 -0400
Date: Mon, 20 Sep 2010 14:40:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.53
Message-ID: <20100920214027.GA26264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.54 kernel.

All users of the 2.6.27 kernel series must upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 arch/ia64/include/asm/compat.h     |    2 +-
 arch/powerpc/include/asm/compat.h  |    2 +-
 arch/s390/include/asm/compat.h     |    2 +-
 arch/sparc/include/asm/compat.h    |    2 +-
 arch/x86/ia32/ia32entry.S          |   22 ++++++++++++++--------
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
 18 files changed, 58 insertions(+), 28 deletions(-)

Anton Vorontsov (1):
      apm_power: Add missing break statement

Dan Carpenter (1):
      irda: off by one

Gary King (1):
      bounce: call flush_dcache_page() after bounce_copy_vec()

Greg Kroah-Hartman (1):
      Linux 2.6.27.54

Guillem Jover (2):
      hwmon: (f75375s) Shift control mode to the correct bit position
      hwmon: (f75375s) Do not overwrite values read from registers

H. Peter Anvin (2):
      x86-64, compat: Test %rax for the syscall number, not %eax
      compat: Make compat_alloc_user_space() incorporate the access_ok()

Luis R. Rodriguez (1):
      ath9k_hw: fix parsing of HT40 5 GHz CTLs

Roland McGrath (1):
      x86-64, compat: Retruncate rax after ia32 syscall entry tracing

Steven Rostedt (1):
      tracing: Do not allow llseek to set_ftrace_filter

Takashi Iwai (1):
      ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()

