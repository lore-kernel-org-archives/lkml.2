Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1BHVxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:53:43 -0500
Received: from ozlabs.org ([203.10.76.45]:33766 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab1BHVxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:53:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio fixes
Date: Wed, 9 Feb 2011 08:23:38 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102090823.39208.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit afe8a887550f7cc24eb16449670b93f6b43c32d8:

  Merge branch 'next' of git://git.monstr.eu/linux-2.6-microblaze (2011-02-02 10:23:58 +1100)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Amit Shah (2):
      virtio: console: Wake up outvq on host notifications
      virtio: console: Update Copyright

 drivers/tty/hvc/virtio_console.c |   18 +++++++++++++++---
 include/linux/virtio_console.h   |    3 ++-
 2 files changed, 17 insertions(+), 4 deletions(-)
