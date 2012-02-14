Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab2BNAjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:39:23 -0500
Received: from ozlabs.org ([203.10.76.45]:46424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682Ab2BNAjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:39:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dave Young <dyoung@redhat.com>, Ondrej Zary <linux@rainbow-software.org>
Subject: [PULL] module fixes.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Feb 2012 11:08:37 +1030
Message-ID: <874nuuckqa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To git@github.com:rustyrussell/linux.git
 + 4f960d5...0d86f65 master -> master (forced update)
 + 96f717e...e45f03a for-linus -> for-linus (forced update)
The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:
  git://github.com/rustyrussell/linux.git master

Dave Young (1):
      module: make module param bint handle nul value

Ondrej Zary (1):
      module: fix broken isapnp handling in file2alias

 kernel/params.c          |    3 ++-
 scripts/mod/file2alias.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)
Cc: Dave Young <dyoung@redhat.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
