Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0IUB1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:27:11 -0400
Received: from ozlabs.org ([203.10.76.45]:53536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0IUB1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:27:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio console fixes and lguest comment fix
Date: Tue, 21 Sep 2010 10:56:34 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        Eviatar Khen <eviatarkhen@gmail.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009211056.37323.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2422084a94fcd5038406261b331672a13c92c050:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../mattst88/alpha-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Amit Shah (1):
      virtio: console: Prevent userspace from submitting NULL buffers

Hans de Goede (1):
      virtio: console: Fix poll blocking even though there is data to read

Rusty Russell (1):
      lguest: update comments to reflect LHCALL_LOAD_GDT_ENTRY.

 arch/x86/lguest/boot.c        |   13 ++++++++-----
 drivers/char/virtio_console.c |    6 +++++-
 2 files changed, 13 insertions(+), 6 deletions(-)
