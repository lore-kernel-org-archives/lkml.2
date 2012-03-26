Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2CZEZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 00:25:22 -0400
Received: from ozlabs.org ([203.10.76.45]:54062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2CZEYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 00:24:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "lkml" <linux-kernel@vger.kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: stable@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Abbott <tim.abbott@oracle.com>
Subject: [PULL] module and param
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 26 Mar 2012 13:04:38 +1030
Message-ID: <87zkb4ay4h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: I'm getting married next week, and then honeymoon until 6th May.
I'll be offline from next week, except to post the compulsory pictures
if Alex shaves her head...

Thanks,
Rusty.

To git@github.com:rustyrussell/linux.git
   4eb05d5..f946eeb  master -> master
 + 847ce6c...9dcbe9d for-linus -> for-linus (forced update)
The following changes since commit e22057c8599373e5caef0bc42bdb95d2a361ab0d:

  Merge tag 'stable/for-linus-3.4-tag-two' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2012-03-24 12:20:25 -0700)

are available in the git repository at:

  git://github.com/rustyrussell/linux.git master

Dave Young (1):
      module: add kernel param to force disable module load

Pawel Moll (1):
      params: <level>_initcall-like kernel parameters

Rusty Russell (1):
      module_param: remove support for bool parameters which are really int.

Sasha Levin (1):
      module: Remove module size limit

Steven Rostedt (1):
      module: move __module_get and try_module_get() out of line.

 Documentation/kernel-parameters.txt |    2 +
 arch/powerpc/mm/hugetlbpage.c       |    3 +-
 include/asm-generic/vmlinux.lds.h   |   35 +++++++-----------
 include/linux/module.h              |   32 ++---------------
 include/linux/moduleparam.h         |   58 +++++++++++++++++++++++--------
 init/main.c                         |   65 +++++++++++++++++++++++++++++++---
 kernel/module.c                     |   37 ++++++++++++++++++--
 kernel/params.c                     |   39 +++++++-------------
 8 files changed, 172 insertions(+), 99 deletions(-)

-- 
  How could I marry someone with more hair than me?  http://baldalex.org
