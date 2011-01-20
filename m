Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1ATLNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:13:37 -0500
Received: from ozlabs.org ([203.10.76.45]:46146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab1ATLNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:13:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest and virtio.
Date: Thu, 20 Jan 2011 21:43:31 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101202143.32012.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8a335bc631ac9c43675821580c26ebf95a3044ba:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6 (2011-01-16 15:06:43 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Christoph Lameter (1):
      lguest: Use this_cpu_ops

Milton Miller (1):
      virtio: remove virtio-pci root device

Philip Sanderson (3):
      lguest: --username and --chroot options
      lguest: example launcher to use guard pages, drop PROT_EXEC, fix limit logic
      lguest: document --rng in example Launcher

Randy Dunlap (1):
      LGUEST_GUEST: fix unmet direct dependencies (VIRTUALIZATION && VIRTIO)

Rusty Russell (1):
      lguest: compile fixes

 Documentation/lguest/lguest.c   |   73 ++++++++++++++++++++++++++++++++++----
 Documentation/lguest/lguest.txt |    5 +++
 arch/x86/lguest/Kconfig         |    1 +
 arch/x86/lguest/boot.c          |    2 +-
 drivers/lguest/page_tables.c    |    2 +-
 drivers/lguest/x86/core.c       |    4 +-
 drivers/virtio/virtio_pci.c     |   20 +---------
 7 files changed, 77 insertions(+), 30 deletions(-)
