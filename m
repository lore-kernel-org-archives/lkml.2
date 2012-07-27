Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2G0Eh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:37:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:56467 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab2G0Eh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:37:26 -0400
Message-ID: <1343363833.2118.14.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jul 2012 14:37:13 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a handful of powerpc patches, a couple of regression fixes
for problems introduced in the main batch in this merge window,
a couple of defconfig updates, and some trivials. The radeonfb
one is something that was long standing in SLES which I forgot
to pickup earlier.

Cheers,
Ben.

The following changes since commit bdc0077af574800d24318b6945cf2344e8dbb050:

  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2012-07-24 18:11:22 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to bac821a6e3404330d509fd3a245bf7701f210c7c:

  powerpc/ftrace: Trace function graph entry before updating index (2012-07-27 11:42:34 +1000)

----------------------------------------------------------------
Alexander Graf (1):
      powerpc/kvm/bookehv: Fix build regression

Anton Blanchard (2):
      powerpc: Enable pseries hardware RNG and crypto modules
      powerpc: Lack of firmware flash support is not an error

Benjamin Herrenschmidt (1):
      powerpc: Update g5_defconfig

Steven Rostedt (1):
      powerpc/ftrace: Trace function graph entry before updating index

Stuart Yoder (1):
      powerpc: Set stack limit properly in crit_transfer_to_handler

Tony Breeds (1):
      radeonfb: Add quirk for the graphics adapter in some JSxx

 arch/powerpc/configs/g5_defconfig      |  103 ++++++++++----------------------
 arch/powerpc/configs/ppc64_defconfig   |    6 +-
 arch/powerpc/configs/pseries_defconfig |    6 +-
 arch/powerpc/kernel/entry_32.S         |   12 +++-
 arch/powerpc/kernel/ftrace.c           |   11 ++--
 arch/powerpc/kernel/rtas_flash.c       |    2 +-
 arch/powerpc/kvm/bookehv_interrupts.S  |   77 ++++++++++++------------
 drivers/video/aty/radeon_monitor.c     |   35 +++++++++++
 8 files changed, 128 insertions(+), 124 deletions(-)


