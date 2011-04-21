Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1DUNdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:33:01 -0400
Received: from ozlabs.org ([203.10.76.45]:53768 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1DUNdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:33:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@osdl.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Subject: [PULL] virtio fixes
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 21 Apr 2011 23:01:04 +0930
Message-ID: <87tydrhgtj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 584f79046780e10cb24367a691f8c28398a00e84:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-04-20 18:18:19 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Amit Shah (3):
      virtio: Decrement avail idx on buffer detach
      virtio_pci: Prevent double-free of pci regions after device hot-unplug
      virtio: console: Enable call to hvc_remove() on console port remove

 drivers/char/virtio_console.c |   11 -----------
 drivers/virtio/virtio_pci.c   |   15 ++++++++-------
 drivers/virtio/virtio_ring.c  |    1 +
 3 files changed, 9 insertions(+), 18 deletions(-)
