Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab1BFXpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:14 -0500
Received: from 1wt.eu ([62.212.114.60]:60254 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab1BFXpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:13 -0500
Message-Id: <20110206232252.509080428@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Subject: [PATCH 00/23] 2.6.27.58-longterm review
Message-ID: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.27.58 release.
This version is up to date with what was merged in 2.6.32.28.

I know it was sensibly delayed, but nothing was critical so I preferred to
ensure that I did not repeat the hackish review process I used to work with
on 2.6.20. Next reviews should take less time. Special thanks to thank Greg
for sharing scripts, ideas and methods to help me catch up with a process I
left a few years ago.

All patches will be posted as a response to this one.  If anyone has any
issues with these being applied, please let me know.  If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by:
line to the patch, please respond with it.

The full quilt queue can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.27.git

Responses should be made within 72 hours. Anything received after that
time might be too late.

The whole patch series can be found in one patch at:
        kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.27.58-rc1.gz
and the diffstat can be found below.

 arch/x86/vdso/Makefile               |    4 +-
 drivers/char/hvc_console.c           |   25 +++++---
 drivers/dma/mv_xor.c                 |    2 +-
 drivers/hid/hidraw.c                 |   11 +++-
 drivers/hwmon/adm1026.c              |   20 +++---
 drivers/infiniband/core/uverbs_cmd.c |  101 +++++++++++++++++++---------------
 drivers/md/md.c                      |    7 ++-
 drivers/usb/misc/uss720.c            |    4 +-
 drivers/usb/storage/unusual_devs.h   |    7 ++
 fs/exec.c                            |    5 ++
 fs/nfs/file.c                        |    2 +
 fs/nfsd/nfs3xdr.c                    |    6 +-
 include/linux/nfsd/xdr4.h            |    4 +-
 include/net/sctp/sm.h                |    1 +
 include/net/sctp/structs.h           |    3 +
 kernel/exit.c                        |    8 +++
 kernel/power/user.c                  |    2 +-
 kernel/trace/trace.c                 |   12 +++-
 mm/mmap.c                            |   16 ++++-
 net/sctp/input.c                     |   22 ++++++-
 net/sctp/sm_sideeffect.c             |   35 ++++++++++++
 net/sctp/transport.c                 |    2 +
 net/sunrpc/svc_xprt.c                |    9 +++-
 sound/oss/soundcard.c                |    4 +-
 sound/pci/hda/hda_intel.c            |    2 +
 sound/pci/hda/patch_realtek.c        |    1 +
 26 files changed, 225 insertions(+), 90 deletions(-)


