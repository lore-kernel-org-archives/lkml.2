Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab0JZCqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:46:35 -0400
Received: from mail.perches.com ([173.55.12.10]:3557 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab0JZCod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:33 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chas Williams <chas@cmf.nrl.navy.mil>, Jiri Kosina <jkosina@suse.cz>,
        Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 00/10] Remove multiple uses of KERN_<level>
Date: Mon, 25 Oct 2010 19:44:18 -0700
Message-Id: <cover.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using strings vmlinux | grep "^<.>.*<.>"
and a couple of other cleanups of logging message format strings.

Joe Perches (10):
  arch/x86/kernel/apic/io_apic.c: Typo fix WARNING
  drivers/atm/eni.c: Remove multiple uses of KERN_<level>
  drivers/hid/hid-input.c: Remove KERN_DEBUG from dbg_hid use
  drivers/infiniband: Remove unnecessary KERN_<level> uses
  drivers/input/mouse/appletouch.c: Remove KERN_DEBUG use from dprintk
  drivers/input/serio/i8042: Use pr_<level>, pr_fmt.  Fix dbg and __FILE__ use
  drivers/media: Removed unnecessary KERN_<level>s from dprintk uses
  drivers/scsi:mvsas/mv_sas.c: Remove KERN_DEBUG from mv_dprintk use
  drivers/video/msm/mddi.c: Remove multiple KERN_<level> uses
  fs/proc/vmcore.c: Use pr_<level> and pr_<fmt>

 arch/x86/kernel/apic/io_apic.c                |    2 +-
 drivers/atm/eni.c                             |    7 +-
 drivers/hid/hid-input.c                       |    2 +-
 drivers/infiniband/hw/amso1100/c2_intr.c      |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c         |    4 +-
 drivers/infiniband/hw/cxgb4/cm.c              |    4 +-
 drivers/input/mouse/appletouch.c              |    2 +-
 drivers/input/serio/i8042.c                   |   94 ++++++++++++-------------
 drivers/input/serio/i8042.h                   |   19 +++--
 drivers/media/common/tuners/max2165.c         |   10 +--
 drivers/media/dvb/frontends/atbm8830.c        |    8 +--
 drivers/media/dvb/frontends/lgs8gxx.c         |   11 +--
 drivers/media/video/saa7134/saa7134-input.c   |    2 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c |   12 ++--
 drivers/scsi/mvsas/mv_sas.c                   |    2 +-
 drivers/video/msm/mddi.c                      |    5 +-
 fs/proc/vmcore.c                              |   16 ++---
 17 files changed, 97 insertions(+), 107 deletions(-)

-- 
1.7.3.dirty

