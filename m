Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2EBU22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:28:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42775 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab2EBU21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:28:27 -0400
Date: Wed, 2 May 2012 13:28:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY VT bugfix for 3.4-rc5
Message-ID: <20120502202823.GA27129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.4-rc6

for you to fetch changes up to 84f904ecd3aa2ccb5779b815b69c1cb592f07bb5:

  vt: Fix deadlock on scroll-lock (2012-05-01 14:01:28 -0400)

----------------------------------------------------------------
TTY fix for 3.4-rc5

This is a deadlock bugfix that was easy to hit, and that the vt layer lock
rework got wrong, so it reverts the logic back to the way it was in 3.3 and
earlier kernels to prevent problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      vt: Fix deadlock on scroll-lock

 drivers/tty/vt/keyboard.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)
