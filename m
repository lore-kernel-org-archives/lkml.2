Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0KXE60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:58:26 -0500
Received: from ozlabs.org ([203.10.76.45]:60219 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab0KXE6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:58:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio fixes (and one trivial module cleanup)
Date: Wed, 24 Nov 2010 15:28:06 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Anders Kaseorg <andersk@ksplice.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Stephen Hemminger <shemminger@vyatta.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011241528.06934.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(lguest is currently broken, but timed out chasing it; expect a patch next
 week once I get back).

The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:

  Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Anders Kaseorg (1):
      module: Update prototype for ref_module (formerly use_module)

Jiri Slaby (1):
      Char: virtio_console, fix memory leak

Michael S. Tsirkin (1):
      virtio: return correct capacity to users

Stephen Hemminger (1):
      virtio: fix format of sysfs driver/vendor files

 drivers/char/virtio_console.c |   37 +++++++++----------------------------
 drivers/virtio/virtio.c       |    6 +++---
 drivers/virtio/virtio_ring.c  |    3 ---
 include/linux/module.h        |    2 +-
 4 files changed, 13 insertions(+), 35 deletions(-)
