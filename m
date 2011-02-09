Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1BIWEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:04:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:35049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1BIWEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:04:51 -0500
Date: Wed, 9 Feb 2011 22:04:30 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Linux 2.6.27.58
Message-ID: <20110209220430.GA17820@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Feb 2011 22:04:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.6.27.58.

As announced with the preview, this version intends to sync up with
relevant fixes merged into 2.6.32.28.

I'll also be replying to this message with a copy of the patch between
2.6.27.57 and 2.6.27.58.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.27/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.27/patch-2.6.27.58.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.27/ChangeLog-2.6.27.58

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.27.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.27.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.27.y.git

Willy

-------

 Makefile                             |    2 
 arch/x86/vdso/Makefile               |    4 -
 drivers/dma/mv_xor.c                 |    2 
 drivers/hid/hidraw.c                 |   11 ++-
 drivers/hwmon/adm1026.c              |   20 +++----
 drivers/infiniband/core/uverbs_cmd.c |   99 +++++++++++++++++++----------------
 drivers/md/md.c                      |    7 +-
 drivers/usb/misc/uss720.c            |    4 +
 drivers/usb/storage/unusual_devs.h   |    7 ++
 fs/exec.c                            |    5 +
 fs/nfs/file.c                        |    2 
 fs/nfsd/nfs3xdr.c                    |    6 +-
 include/linux/nfsd/xdr4.h            |    4 -
 include/net/sctp/sm.h                |    1 
 include/net/sctp/structs.h           |    3 +
 kernel/exit.c                        |    8 ++
 kernel/power/user.c                  |    2 
 kernel/trace/trace.c                 |   12 +++-
 mm/mmap.c                            |   16 ++++-
 net/sctp/input.c                     |   22 ++++++-
 net/sctp/sm_sideeffect.c             |   35 ++++++++++++
 net/sctp/transport.c                 |    2 
 net/sunrpc/svc_xprt.c                |    9 ++-
 sound/oss/soundcard.c                |    4 -
 sound/pci/hda/hda_intel.c            |    2 
 sound/pci/hda/patch_realtek.c        |    1 
 26 files changed, 209 insertions(+), 81 deletions(-)

Summary of changes from 2.6.27.57 to 2.6.27.58
============================================

Dan Carpenter (1):
      IB/uverbs: Handle large number of entries in poll CQ

Dan Rosenberg (1):
      sound: Prevent buffer overflow in OSS load_mixer_volumes

Daniel T Chen (3):
      ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
      ALSA: hda: Use LPIB for Dell Latitude 131L
      ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120

Gabriele Gorla (2):
      hwmon: (adm1026) Allow 1 as a valid divider value
      hwmon: (adm1026) Fix setting fan_div

H. Peter Anvin (1):
      x86, gcc-4.6: Use gcc -m options when building vdso

Jiri Slaby (1):
      HID: hidraw: fix window in hidraw_release

Neil Brown (1):
      nfsd: Fix possible BUG_ON firing in set_change_info

NeilBrown (2):
      md: fix bug with re-adding of partially recovered device.
      sunrpc: prevent use-after-free on clearing XPT_BUSY

Oleg Nesterov (1):
      posix-cpu-timers: workaround to suppress the problems with mt exec

Saeed Bishara (1):
      mv_xor: fix race in tasklet function

Sergey Vlasov (1):
      NFS: Fix fcntl F_GETLK not reporting some conflicts

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing

Takashi Iwai (1):
      PM / Hibernate: Fix PM_POST_* notification with user-space suspend

Tavis Ormandy (1):
      install_special_mapping skips security_file_mmap check.

Thomas Sailer (1):
      USB: misc: uss720.c: add another vendor/product ID

Vitaly Kuznetsov (1):
      USB: usb-storage: unusual_devs entry for the Samsung YP-CP3

Vlad Yasevich (1):
      sctp: Fix a race between ICMP protocol unreachable and connect()

Willy Tarreau (1):
      Linux 2.6.27.58

