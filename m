Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab1D0SYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:24:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35504 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab1D0SYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:24:17 -0400
Date: Wed, 27 Apr 2011 11:24:39 -0700
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Revert wrong misspelling fixes
Message-ID: <20110427182439.GA1923@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Please pull this for undoing the wrong fixes made by codespell as pointed by
you and Ingo.


Lucas De Marchi



The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:

  Linux 2.6.39-rc5 (2011-04-26 20:48:50 -0700)

are available in the git repository at:
  git://git.profusion.mobi/users/lucas/linux-2.6.git spell-fix

Lucas De Marchi (1):
      Revert wrong fixes for common misspellings

 arch/arm/mach-davinci/dm355.c                |    2 +-
 arch/arm/mach-davinci/dm644x.c               |    2 +-
 arch/powerpc/include/asm/uninorth.h          |    2 +-
 drivers/infiniband/hw/qib/qib_iba6120.c      |    2 +-
 drivers/infiniband/hw/qib/qib_iba7220.c      |    2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c      |    2 +-
 drivers/media/radio/radio-sf16fmr2.c         |    2 +-
 drivers/mtd/nand/diskonchip.c                |    2 +-
 drivers/pcmcia/pcmcia_resource.c             |    2 +-
 drivers/staging/rt2860/common/cmm_data_pci.c |    2 +-
 drivers/staging/rt2860/common/cmm_data_usb.c |    2 +-
 drivers/staging/spectra/ffsport.c            |    2 +-
 drivers/staging/tidspbridge/dynload/cload.c  |    2 +-
 drivers/staging/tty/specialix.c              |    2 +-
 fs/btrfs/ctree.h                             |    2 +-
 fs/ocfs2/ocfs2_fs.h                          |    2 +-
 net/l2tp/l2tp_ip.c                           |    2 +-
 net/sctp/ulpevent.c                          |    2 +-
 sound/aoa/codecs/tas.c                       |    2 +-
 19 files changed, 19 insertions(+), 19 deletions(-)
