Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab0HEDaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:30:01 -0400
Received: from ozlabs.org ([203.10.76.45]:35800 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758674Ab0HED35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:29:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] modules
Date: Thu, 5 Aug 2010 12:59:53 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008051259.54472.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pretty happy with this; there have been no complaints since that initial
flurry of fixes.

The following changes since commit 3cfc2c42c1cbc8e238bb9c0612c0df4565e3a8b4:
  Linus Torvalds (1):
        Merge branch 'for-next' of git://git.kernel.org/.../jikos/trivial

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git modules

Eric Dumazet (1):
      module: module_unload_init() cleanup

Linus Torvalds (4):
      module: refactor load_module
      module: refactor load_module part 2
      module: reduce stack usage for each_symbol()
      module: add load_info

Rusty Russell (14):
      module: refactor load_module part 3
      module: refactor load_module part 4
      module: refactor load_module part 5
      module: refactor out section header rewriting
      module: refactor out section header rewriting: FIX modversions
      module: kallsyms functions take struct load_info
      module: fix crash in get_ksymbol() when oopsing in module init
      module: layout_and_allocate
      module: sysfs cleanup
      module: fix sysfs cleanup for !CONFIG_SYSFS
      module: pass load_info into other functions
      module: move module args strndup_user to just before use
      module: group post-relocation functions into post_relocation()
      module: cleanup comments, remove noinline

 kernel/module.c | 1088 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 581 insertions(+), 507 deletions(-)
