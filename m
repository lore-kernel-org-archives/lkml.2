Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab2KIEph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:45:37 -0500
Received: from ozlabs.org ([203.10.76.45]:36172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2KIEpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:45:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Bruno Wolff III <bruno@wolff.to>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Masaki Kimura <masaki.kimura.kz@hitachi.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PULL] virtio and two module fixes
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 09 Nov 2012 15:13:46 +1030
Message-ID: <874nkz2xod.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit bc909421a9c7083fcde795846d22b36a51a7be54:

  Merge tag 'gpio-fixes-v3.7-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2012-10-30 15:56:22 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git fixes

for you to fetch changes up to 237242bddc99041e15a4ca51b8439657cadaff17:

  virtio: Don't access index after unregister. (2012-11-09 14:54:24 +1030)

----------------------------------------------------------------
YA module signing build tweak, and two cc'd to stable.

----------------------------------------------------------------
Cornelia Huck (1):
      virtio: Don't access index after unregister.

Rusty Russell (2):
      module: fix out-by-one error in kallsyms
      modules: don't break modules_install on external modules with no key.

 drivers/virtio/virtio.c  |    4 +++-
 kernel/module.c          |   27 ++++++++++++++++-----------
 scripts/Makefile.modinst |    3 ++-
 3 files changed, 21 insertions(+), 13 deletions(-)
