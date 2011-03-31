Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1CaCSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:18:18 -0400
Received: from ozlabs.org ([203.10.76.45]:36455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab1CaCSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:18:16 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Merge window closed - 2.6.39-rc1 out
In-Reply-To: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
References: <AANLkTikwbY5mm10ZWg7B6XeSBkZXFqKcYVZfJCi2QGx_@mail.gmail.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 31 Mar 2011 12:47:14 +1030
Message-ID: <87wrjg11at.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 14:07:35 -0700, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> So 2.6.39-rc1 is out there, and the merge window is closed.

Oops, I somehow missed this.  Kernel must be getting boring.

If you're feeling generous, please pull.  If not, I'll separate out the
one with CC:stable in it and send another request.

The following changes since commit 6aba74f2791287ec407e0f92487a725a25908067:

  Merge branch 'irq-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-03-30 09:35:52 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Amit Shah (3):
      virtio: Decrement avail idx on buffer detach
      virtio_pci: Prevent double-free of pci regions after device hot-unplug
      virtio: console: Enable call to hvc_remove() on console port remove

Christoph Hellwig (1):
      virtio_blk: allow re-reading config space at runtime

Daniel J Blueman (1):
      minor ANSI prototype sparse fix

Dmitry Torokhov (2):
      module: deal with alignment issues in built-in module versions
      module: do not hide __modver_version_show declaration behind ifdef

Richard Kennedy (2):
      module: remove 64 bit alignment padding from struct module with CONFIG_TRACE*
      module: reorder kparam_array to remove alignment padding on 64 bit builds

Rusty Russell (1):
      virtio console: don't manually set or finalize VIRTIO_CONSOLE_F_MULTIPORT.

 drivers/block/virtio_blk.c    |   88 ++++++++++++++++++++++++++++++++++++-----
 drivers/char/virtio_console.c |   16 -------
 drivers/virtio/virtio_pci.c   |   15 ++++---
 drivers/virtio/virtio_ring.c  |    1 +
 include/linux/module.h        |   28 +++++++------
 include/linux/moduleparam.h   |    7 ++-
 kernel/module.c               |    4 +-
 kernel/params.c               |    9 +++-
 8 files changed, 114 insertions(+), 54 deletions(-)

Cheers,
Rusty.
