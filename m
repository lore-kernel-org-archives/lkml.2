Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593Ab2FHFzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:55:47 -0400
Received: from ozlabs.org ([203.10.76.45]:46752 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965Ab2FHFzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:55:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Subject: [PULL] Minor module param fixes.
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 08 Jun 2012 15:01:29 +0930
Message-ID: <87pq9aid3i.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git tags/moduleparam-for-linus

for you to fetch changes up to 19efb72fdc3c3bbfb929d91e34312b0494f14409:

  init: Drop initcall level output (2012-06-08 14:58:14 +0930)

----------------------------------------------------------------
One bugfix for multiple moduleparam levels, one removal of overzealous printk.

----------------------------------------------------------------
Borislav Petkov (1):
      init: Drop initcall level output

Rusty Russell (1):
      module_param: stop double-calling parameters.

 include/linux/moduleparam.h |   10 +++++-----
 init/main.c                 |    9 ++-------
 2 files changed, 7 insertions(+), 12 deletions(-)
