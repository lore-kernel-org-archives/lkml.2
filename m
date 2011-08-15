Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1HOBB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 21:01:58 -0400
Received: from ozlabs.org ([203.10.76.45]:56639 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1HOBBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 21:01:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: [PULL] lguest fix, virtio documentation
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 15 Aug 2011 10:25:00 +0930
Message-ID: <87sjp37au3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This adds a text copy of the virtio draft spec to the kernel source,
  which should make it easier for people to find and read.  The master
  is still the lyx document on my server, so I'll keep it in sync. ]

The following changes since commit 91d85ea6786107aa2837bef3e957165ad7c8b823:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-08-13 18:37:28 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (2):
      virtio: Add text copy of spec to Documentation/virtual.
      lguest: allow booting guest with CONFIG_RELOCATABLE=y

 Documentation/virtual/00-INDEX        |    3 +
 Documentation/virtual/lguest/lguest.c |    3 +
 Documentation/virtual/virtio-spec.txt | 2200 +++++++++++++++++++++++++++++++++
 3 files changed, 2206 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/virtual/virtio-spec.txt
