Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2LMAHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:07:09 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64182 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2LMAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:07:06 -0500
Date: Wed, 12 Dec 2012 16:07:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] EXTCON patches for 3.8-rc1
Message-ID: <20121213000700.GA23442@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 70e78c40ed6c25bb34d642848e485d79ffc55c26:

  MAINTAINERS: remove drivers/staging/hv/ (2012-11-26 16:19:01 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.8-rc1

for you to fetch changes up to 962b686c450493adb8596e813bdfd0e1613482e6:

  Merge tag 'pull_req_20121122' of git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon into char-misc-next (2012-11-27 06:44:10 -0800)

----------------------------------------------------------------

EXTCON patches for 3.8-rc1

Here are some drivers/extcon/ patches that I forgot to have you pull in
the larger char/misc patchset from yesterday, for the 3.8-rc1 kernel.

Nothing major here, just some driver updates, and cleanups, all of which
have been in linux-next for a while now.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexey Khoroshilov (1):
      extcon: arizona: unlock mutex on error path in arizona_micdet()

Chanwoo Choi (1):
      extcon: Add missing header file to extcon.h

Greg Kroah-Hartman (1):
      Merge tag 'pull_req_20121122' of git://git.kernel.org/.../mzx/extcon into char-misc-next

MyungJoo Ham (1):
      extcon: kernel_doc style fix

Sachin Kamat (9):
      extcon: Fix return value in extcon-class.c
      extcon: max8997: Fix incorrect error check and return value
      extcon: max77693: Fix incorrect error check and return value
      extcon: max77693: Fix coding style
      extcon: max8997: Fix checkpatch error
      extcon: max8997: Fix a typo
      extcon: max8997: Use devm_kzalloc
      extcon: max77693: Use devm_kzalloc
      extcon: max77693: Fix uninitialised variable warning

 drivers/extcon/extcon-arizona.c  |  1 +
 drivers/extcon/extcon-class.c    |  2 +-
 drivers/extcon/extcon-max77693.c | 36 ++++++++++++++++--------------------
 drivers/extcon/extcon-max8997.c  | 28 ++++++++++++----------------
 include/linux/extcon.h           | 50 ++++++++++++++++++++++++++------------------------
 5 files changed, 56 insertions(+), 61 deletions(-)
